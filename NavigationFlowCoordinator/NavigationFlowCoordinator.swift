//
//  NavigationFlowCoordinator.swift
//  NavigationFlowCoordinator
//
//  Created by Marek Świecznik on 09/12/16.
//  Copyright © 2016 RnDity. All rights reserved.
//

import UIKit

/**
 Base implementation of navigation flow coordinator.
 Intended to be subclassed by specific coordinator implementations.
 
 Functionality it provides:
 
 - starts with specific view controller being defined by overriding createMainViewController() function.
 - hosts instance of UINavigationViewController that is used for presenting related UIViewControllers. The instance is shared among coordinators binded with parent-child relationship chain (unless navigationController property is overriden).
 - start child coordinator being then persistantly coupled by parent-child relationship
 - automatically tracks child coordinators references. There is no need to save reference to coordinator explicitly. The coordinator reference will be automatically released when coordnator mainViewController is popped or the coordinator simply finishes its flow.
 - provides series of method for presenting and dismissing related UIViewControllers either using navigationController or modally
 */
open class NavigationFlowCoordinator: FlowCoordinator {

    private var navigationCoordinatorsTracker: NavigationControllerCoordinatorsTracker!

    /// UINavigationController instance being used to present view controllers hosted by coordinator
    open var navigationController: UINavigationController {
        return navigationCoordinatorsTracker.navigationController
    }

    /// mainViewController is view controller instance created as a result of createMainViewController() call
    /// and presented as very first VC in coordinator flow
    private(set) var mainViewController: UIViewController?

    /// creates view controller that is used then as mainViewController
    /// called during coordinator start
    ///
    /// - Returns: view controller being set as mainViewController and presented as very first VC in coordinator flow
    open func createMainViewController() -> UIViewController? {
        return nil
    }


    // MARK: - FlowCoordinator overrides

    override open func start(with presentationStyle: NavigationStyle, animated: Bool = true) {
        if navigationCoordinatorsTracker == nil {
            navigationCoordinatorsTracker = NavigationControllerCoordinatorsTracker()
        }

        if let viewController = createMainViewController() {
            mainViewController = viewController

            if let mainVC = mainViewController {
                navigate(to: mainVC, with: presentationStyle, animated: animated)
            }
        }
    }

    override open func start(childCoordinator: FlowCoordinator, with presentationStyle: NavigationStyle, animated: Bool = true) {
        let childNavigationFlowCoordinator = childCoordinator as? NavigationFlowCoordinator

        childNavigationFlowCoordinator?.navigationCoordinatorsTracker = self.navigationCoordinatorsTracker

        super.start(childCoordinator: childCoordinator, with: presentationStyle, animated: animated)
    }

    override open func finish() {
        popAllRelatedViewControllers()
    }

    override open var coordinatorsTracker: CoordinatorsTracker? {
        return navigationCoordinatorsTracker
    }


    // MARK: - Navigation controller related flow

    func navigate(to viewController: UIViewController, with presentationStyle: NavigationStyle, animated: Bool = true) {
        switch presentationStyle {
        case .present:
            present(viewController: viewController, animated: animated)
        case .push:
            push(viewController: viewController, animated: animated)
        }
    }

    /// push viewController onto navigation controller
    ///
    /// - Parameters:
    ///   - viewController: view controller to be pushed
    ///   - animated: is transition animated
    public func push(viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    /// pops all related view controllers including main one
    ///
    /// - Parameter animated: is transition animated
    public func popAllRelatedViewControllers(animated: Bool = true) {
        assert(mainViewController != nil, "mainViewController can not be nil in context of: \(#function)")

        guard let mainViewController = mainViewController, let index = navigationController.viewControllers.index(of: mainViewController) else {
            return
        }

        if index > 0 {
            navigationController.popToViewController(navigationController.viewControllers[index - 1], animated: animated)
        } else {
            clearNavigationControllerStack()
            self.mainViewController = nil
        }
    }

    /// pops last view controller from navigation controller
    ///
    /// - Parameter animated: is transition animated
    public func popLastViewController(animated: Bool = true) {
        _ = navigationController.popViewController(animated: animated)
    }

    /// pops view controllers until main one is on top of navigation controller
    ///
    /// - Parameter animated: is transition animated
    public func popToMainViewController(animated: Bool = true) {
        assert(mainViewController != nil, "mainViewController can not be nil in context of: \(#function)")

        if let mainViewController = mainViewController {
            _ = navigationController.popToViewController(mainViewController, animated: animated)
        }
    }

    /// pops view controllers until viewController is on top of navigation controller
    ///
    /// - Parameters:
    ///   - viewController: viewController to be popped to
    ///   - animated: is transition animated
    public func pop(toViewController viewController: UIViewController, animated: Bool = true) {
        _ = navigationController.popToViewController(viewController, animated: animated)
    }

    /// pops view controllers until the main view controller of root coordinator is on top
    /// it will result in all child coordinators will be finished the only one left started will be root coordinator (the one withou parent coordinator)
    public func popToNavigationRoot() {
        var rootCoordinator: NavigationFlowCoordinator = self

        while rootCoordinator.parentCoordinator as? NavigationFlowCoordinator != nil {
            rootCoordinator = rootCoordinator.parentCoordinator as! NavigationFlowCoordinator
        }

        rootCoordinator.popToMainViewController()
    }

    /// instantly removes all view controllers from navigation controller
    public func clearNavigationControllerStack() {
        navigationController.viewControllers = []
        forceUpdateTrackingStatus()
    }

    /// Force tracking status update.
    /// Updating tracking status bases on navigationController delegate "willShow viewController" method.
    /// This method might not be called in some cases, i.e. when coordinator `mainViewController` is instantly replaced with other view controller (i.e by starting another child coordinator without animation)
    /// In this case the caller might need to force updating the tracking status so that coordinator object gets released
    open func forceUpdateTrackingStatus() {
        navigationCoordinatorsTracker.updateTrackingStatus()
    }


    // MARK: - Modal VCs

    /// present view controller modally over navigation controller
    ///
    /// - Parameters:
    ///   - viewController: view controller to be presented
    ///   - animated: is transition animated
    ///   - completion: closure called when transition is finished
    public func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        let nvc = UINavigationController(rootViewController: viewController)    // add standard UINVC bar
        navigationController.present(nvc, animated: true, completion: completion)
//        navigationController.present(viewController, animated: true, completion: completion)
    }

    /// dismiss specific view controller
    ///
    /// - Parameters:
    ///   - viewController: view controller to be dismissed
    ///   - animated: is transition animated
    public func dismiss(viewController: UIViewController, animated: Bool = true) {
        viewController.dismiss(animated: animated, completion: nil)
        forceUpdateTrackingStatus()
    }

    /// dismiss last modal view controller
    ///
    /// - Parameters:
    ///   - animated: is transition animated
    ///   - completion: closure called when transition is finished
    public func dismissLastViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
        forceUpdateTrackingStatus()

    }


    // MARK: - private methods
/*
    private func presentMainViewController() {
        assert(mainViewController != nil, "mainViewController can not be nil in context of: \(#function)")

        if let mainViewController = mainViewController {
            push(viewController: mainViewController, animated: initialPushAnimated)
        }
    }
*/
}

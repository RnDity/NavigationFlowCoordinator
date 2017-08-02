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
 
 Functionallity it provides:
 
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

    /// mainViewController is view controller instace created as a result of createMainViewController() call
    /// and presented as very first VC in coordinator flow
    private(set) var mainViewController: UIViewController!
    
    
    /// creates view controller that is used then as mainViewController
    /// called during coordinator start
    ///
    /// - Returns: view controller being set as mainViewController and presented as very first VC in coordinator flow
    open func createMainViewController() -> UIViewController? {
        return nil
    }
    
    
    /// Force tracking status update.
    /// Updating tracking status bases on navigationController delegate "willShow viewController" method.
    /// This method might be not called in same cases, i.e. when coordinator mainViewController is is instantly replaced with other view controller (i.e by starting other child coordinator without animation)
    /// In this case the caller might force updating tracking status so that coordinator object gets released
    public func forceUpdateTrackingStatus() {
        navigationCoordinatorsTracker.updateTrackingStatus()
    }
    
    
    // MARK: FlowCoordinator overrides
    
    override open var coordinatorsTracker: CoordinatorsTracker? {
        return navigationCoordinatorsTracker
    }
    
    override open func start() {
        if navigationCoordinatorsTracker == nil {
            navigationCoordinatorsTracker = NavigationControllerCoordinatorsTracker()
        }
        
        if let viewController = createMainViewController() {
            mainViewController = viewController
            presentMainViewController()
        }
    }
    
    override open func finish() {
        popAllRelatedViewControllers()
    }
    
    override open func start(childCoordinator: FlowCoordinator) {
        let childNavigationFlowCoordinator = childCoordinator as? NavigationFlowCoordinator
        
        childNavigationFlowCoordinator?.navigationCoordinatorsTracker = self.navigationCoordinatorsTracker
        
        super.start(childCoordinator: childCoordinator)
    }
    
    
    // MARK: Navigation controller related flow
    
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
        if let index = navigationController.viewControllers.index(of: mainViewController), index > 0 {
            navigationController.popToViewController(navigationController.viewControllers[index - 1], animated: animated)
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
        _ = navigationController.popToViewController(mainViewController, animated: animated)
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
    
    
    // MARK: Modal VCs
    
    /// present view controller modally over navigation controller
    ///
    /// - Parameters:
    ///   - viewController: view controller to be presented
    ///   - animated: is transition animated
    ///   - completion: closure called when transition is finished
    public func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.present(viewController, animated: true, completion: completion)
    }
    
    /// dismiss specific view controller
    ///
    /// - Parameters:
    ///   - viewController: view controller to be dismissed
    ///   - animated: is transition animated
    public func dismiss(viewController: UIViewController, animated: Bool = true) {
        viewController.dismiss(animated: animated, completion: nil)
    }
    
    /// dismiss last modal view controller
    ///
    /// - Parameters:
    ///   - animated: is transition animated
    ///   - completion: closure called when transition is finished
    public func dismissLastViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    
    // MARK: private methods

    private func presentMainViewController() {
        push(viewController: mainViewController, animated: true)
    }
}

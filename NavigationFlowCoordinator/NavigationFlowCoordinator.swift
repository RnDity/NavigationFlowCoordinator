//
//  NavigationFlowCoordinator.swift
//  NavigationFlowCoordinator
//
//  Created by Marek Świecznik on 09/12/16.
//  Copyright © 2016 RnDity. All rights reserved.
//

import UIKit

open class NavigationFlowCoordinator: FlowCoordinator {
    public var navigationController: UINavigationController {
        return navigationCoordinatorsTracker.navigationController
    }
    
    override open var coordinatorsTracker: CoordinatorsTracker? {
        return navigationCoordinatorsTracker
    }
    
    private var navigationCoordinatorsTracker: NavigationControllerCoordinatorsTracker!
    private(set) var mainViewController: UIViewController!
    
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
    
    open func createMainViewController() -> UIViewController? {
        return nil
    }
    
    override open func start(childCoordinator: FlowCoordinator) {
        let childNavigationFlowCoordinator = childCoordinator as? NavigationFlowCoordinator
        
        childNavigationFlowCoordinator?.navigationCoordinatorsTracker = self.navigationCoordinatorsTracker
        
        super.start(childCoordinator: childCoordinator)
    }

    public func presentMainViewController() {
        push(viewController: mainViewController, animated: true)
    }
    
    public func forceUpdateTrackingStatus() {
        navigationCoordinatorsTracker.updateTrackingStatus()
    }
    
    
    // MARK: Navigation controller related flow
    
    public func push(viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    public func popAllRelatedViewControllers(animated: Bool = true) {
        if let index = navigationController.viewControllers.index(of: mainViewController), index > 0 {
            navigationController.popToViewController(navigationController.viewControllers[index - 1], animated: animated)
        }
    }
    
    public func popLastViewController(animated: Bool = true) {
        _ = navigationController.popViewController(animated: animated)
    }
    
    public func popToMainViewController(animated: Bool = true) {
        _ = navigationController.popToViewController(mainViewController, animated: animated)
    }
    
    public func pop(toViewController viewController: UIViewController, animated: Bool = true) {
        _ = navigationController.popToViewController(viewController, animated: animated)
    }
    
    public func popToNavigationRoot() {
        var rootCoordinator: NavigationFlowCoordinator = self
        
        while rootCoordinator.parentCoordinator as? NavigationFlowCoordinator != nil {
            rootCoordinator = rootCoordinator.parentCoordinator as! NavigationFlowCoordinator
        }
        
        rootCoordinator.popToMainViewController()
    }
    
    // MARK: Modal VCs
    public func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.present(viewController, animated: true, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool = true) {
        viewController.dismiss(animated: animated, completion: nil)
    }
    
    public func dismissLastViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
}

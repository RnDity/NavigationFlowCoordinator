//
//  NavigationControllerCoordinatorsTracker.swift
//  NavigationFlowCoordinator
//
//  Created by Rafał Urbaniak on 04/07/2017.
//
//

import Foundation

/// Automatically tracks coordinator references when starting child coordinator
public class NavigationControllerCoordinatorsTracker: NSObject  {
    
    
    /// root navigation cotroller
    let navigationController = UINavigationController()
    
    
    /// force tracking status update
    /// might be useful in case when method navigationController delegate "willShow viewController" method is not called for some reason
    /// i.e. when coordinator mainViewController is is instantly covered with other view controller (i.e by starting other child coordinator without animation)
    public func updateTrackingStatus() {
        cleanUpChildCoordinators()
    }
    
    
    fileprivate var viewControllersToChildCoordinators = [UIViewController: Coordinator]()
    
    override init() {
        super.init()
        navigationController.delegate = self
    }
    
    fileprivate func cleanUpChildCoordinators() {
        for viewController in viewControllersToChildCoordinators.keys {
            if !navigationController.viewControllers.contains(viewController) && navigationController.presentedViewController != viewController {
                viewControllersToChildCoordinators.removeValue(forKey: viewController)
            }
        }
    }
}

extension NavigationControllerCoordinatorsTracker: CoordinatorsTracker {
    public func track(coordinator: Coordinator) {
        if let navigationFlowCoordinator = coordinator as? NavigationFlowCoordinator, let mainViewController = navigationFlowCoordinator.mainViewController {
            viewControllersToChildCoordinators[mainViewController] = navigationFlowCoordinator
        }
    }
}

extension NavigationControllerCoordinatorsTracker: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        cleanUpChildCoordinators()
    }
}

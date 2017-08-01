//
//  NavigationControllerCoordinatorsTracker.swift
//  NavigationFlowCoordinator
//
//  Created by Rafał Urbaniak on 04/07/2017.
//
//

import Foundation

public class NavigationControllerCoordinatorsTracker: NSObject, CoordinatorsTracker  {
    
    let navigationController = UINavigationController()
    fileprivate var viewControllersToChildCoordinators = [UIViewController: Coordinator]()
    
    override init() {
        super.init()
        navigationController.delegate = self
    }
    
    public func track(coordinator: Coordinator) {
        if let navigationFlowCoordinator = coordinator as? NavigationFlowCoordinator, let mainViewController = navigationFlowCoordinator.mainViewController {
            viewControllersToChildCoordinators[mainViewController] = navigationFlowCoordinator
        }
    }
    
    public func updateTrackingStatus() {
        cleanUpChildCoordinators()
    }
    
    fileprivate func cleanUpChildCoordinators() {
        for viewController in viewControllersToChildCoordinators.keys {
            if !navigationController.viewControllers.contains(viewController) && navigationController.presentedViewController != viewController {
                viewControllersToChildCoordinators.removeValue(forKey: viewController)
            }
        }
    }
}

extension NavigationControllerCoordinatorsTracker: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        cleanUpChildCoordinators()
    }
}

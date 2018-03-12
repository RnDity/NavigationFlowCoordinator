//
//  AboutAppCoordinator.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Sebastian Dwornik on 2018-03-10.
//  Copyright © 2018 Applied PDA Software. All rights reserved.
//

import Foundation
import NavigationFlowCoordinator

class AboutAppCoordinator: NavigationFlowCoordinator {

    var aboutAppViewController: AboutAppViewController!

    override init() {
        super.init()
    }

    override func createMainViewController() -> UIViewController? {
        aboutAppViewController = AboutAppViewController()
        aboutAppViewController.flowDelegate = self
        return aboutAppViewController
    }
}

extension AboutAppCoordinator: AboutAppFlowDelegate {
    func DismissVC() {
        dismissLastViewController()
    }
}

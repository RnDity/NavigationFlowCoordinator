//
//  Coordinator.swift
//  NavigationFlowCoordinator
//
//  Created by Rafał Urbaniak on 01/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation


public enum NavigationStyle: Int {
    case present
    case push
}


public protocol Coordinator: class {
    /// starts coordinator flow
    func start(with presentationStyle: NavigationStyle, animated: Bool)

    /// finish coordinator flow
    func finish()
}

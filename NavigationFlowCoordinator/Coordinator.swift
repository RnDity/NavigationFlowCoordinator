//
//  Coordinator.swift
//  NavigationFlowCoordinator
//
//  Created by Rafał Urbaniak on 01/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation


public enum navigationStyle: Int {
    case present
    case push
}


public protocol Coordinator: class {
    /// starts coordinator flow
    func start(with presentationStyle: navigationStyle, animated: Bool)

    /// finish coordinator flow
    func finish()
}

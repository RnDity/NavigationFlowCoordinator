//
//  Coordinator.swift
//  NavigationFlowCoordinator
//
//  Created by Rafał Urbaniak on 01/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation

@objc public protocol Coordinator: class {
    /// starts coordinator flow
    func start()
    
    /// finish coordinator flow
    func finish()
}

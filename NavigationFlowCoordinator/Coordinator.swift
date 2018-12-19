//
//  Coordinator.swift
//  NavigationFlowCoordinator
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public protocol Coordinator: class {
    /// starts coordinator flow
    func start()
    
    /// finish coordinator flow
    func finish()
}

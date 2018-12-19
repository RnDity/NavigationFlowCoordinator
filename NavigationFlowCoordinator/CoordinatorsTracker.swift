//
//  CoordinatorsTracker.swift
//  NavigationFlowCoordinator
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public protocol CoordinatorsTracker {
    /// gives a chance to track the coordinator reference in a custom way
    ///
    /// - Parameter coordinator: coordinator to track
    func track(coordinator: Coordinator)
}

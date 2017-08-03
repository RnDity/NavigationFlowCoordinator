//
//  CoordinatorsTracker.swift
//  NavigationFlowCoordinator
//
//  Created by Rafał Urbaniak on 29/06/2017.
//  Copyright © 2017 RnDity. All rights reserved.
//

import Foundation

public protocol CoordinatorsTracker {
    /// gives a chance to track the coordinator reference in a custom way
    ///
    /// - Parameter coordinator: coordinator to track
    func track(coordinator: Coordinator)
}

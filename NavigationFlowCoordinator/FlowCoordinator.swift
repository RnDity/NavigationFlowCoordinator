//
//  FlowCoordinator.swift
//  NavigationFlowCoordinator
//
//  Created by Rafał Urbaniak on 29/06/2017.
//  Copyright © 2017 RnDity. All rights reserved.
//

import Foundation

open class FlowCoordinator: NSObject, Coordinator {
    weak var parentCoordinator: FlowCoordinator?
    
    var coordinatorsTracker: CoordinatorsTracker? {
        return nil
    }
    
    open func start() {
        fatalError("start() method has to be overriden by FlowCoordinator subclass")
    }
    
    open func finish() { }
    
    open func start(childCoordinator: FlowCoordinator) {
        childCoordinator.parentCoordinator = self
        childCoordinator.start()
        coordinatorsTracker?.track(coordinator: childCoordinator)
    }
    
    open func handle(flowEvent: FlowEvent) -> Bool {
        return false
    }
    
    public func send(flowEvent: FlowEvent) {
        handleInternally(flowEvent: flowEvent)
    }
    
    private func handleInternally(flowEvent: FlowEvent) {
        if !handle(flowEvent: flowEvent) {
            parentCoordinator?.handleInternally(flowEvent: flowEvent)
        }
    }
}

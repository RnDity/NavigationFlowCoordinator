//
//  MovieCreateOrUpdateCoordinator.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 03/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation

import NavigationFlowCoordinator

class MovieCreateOrUpdateCoordinator: NavigationFlowCoordinator {
    var connection: Connection
    var movieId: String?
    
    init(connection: Connection, movieId: String?) {
        self.connection = connection
        self.movieId = movieId
        super.init()
    }
    
    override func createMainViewController() -> UIViewController? {
        let vc = MovieCreateOrUpdateViewController(connection: connection, movieId: movieId)
        vc.flowDelegate = self
        return vc
    }
}

extension MovieCreateOrUpdateCoordinator: MovieCreateOrUpdateFlowDelegate {
    func onMovieUpdated() {
        if let movieId = movieId {
            send(flowEvent: MovieUpdatedFlowEvent(movieId: movieId))
        }
        popLastViewController()
    }
    
    func onMovieCreated() {
        send(flowEvent: MovieCreatedFlowEvent())
        popLastViewController()
    }
}

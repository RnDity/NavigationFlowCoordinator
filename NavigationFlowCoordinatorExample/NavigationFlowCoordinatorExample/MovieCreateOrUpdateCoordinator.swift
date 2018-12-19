//
//  MovieCreateOrUpdateCoordinator.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
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

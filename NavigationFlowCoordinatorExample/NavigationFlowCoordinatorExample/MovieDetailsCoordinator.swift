//
//  MovieDetailsCoordinator.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import NavigationFlowCoordinator

class MovieDetailsCoordinator: NavigationFlowCoordinator {
    var connection: Connection
    var movieId: String
    
    var movieDetailsViewController: MovieDetailsViewController!
    
    init(connection: Connection, movieId: String) {
        self.connection = connection
        self.movieId = movieId
        super.init()
    }
    
    override func createMainViewController() -> UIViewController? {
        movieDetailsViewController = MovieDetailsViewController(connection: connection, movieId: movieId)
        movieDetailsViewController.flowDelegate = self
        return movieDetailsViewController
    }
    
    override func handle(flowEvent: FlowEvent) -> Bool {
        if let movieUpdatedFlowEvent = flowEvent as? MovieUpdatedFlowEvent, movieUpdatedFlowEvent.movieId == movieId {
            movieDetailsViewController.invalidateMovieData()
        }
        return false
    }
}

extension MovieDetailsCoordinator: MovieDetailsFlowDelegate {
    func editMovie() {
        start(childCoordinator: MovieCreateOrUpdateCoordinator(connection: connection, movieId: movieId))
    }
    
    func onMovieUpdated() {
        send(flowEvent: MovieUpdatedFlowEvent(movieId: movieId))
    }
}

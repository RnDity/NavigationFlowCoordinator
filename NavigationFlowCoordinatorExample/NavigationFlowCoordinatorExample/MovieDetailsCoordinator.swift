//
//  MovieDetailsCoordinator.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 03/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
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
        start(childCoordinator: MovieCreateOrUpdateCoordinator(connection: connection, movieId: movieId), with: .push)
    }

    func onMovieUpdated() {
        send(flowEvent: MovieUpdatedFlowEvent(movieId: movieId))
    }
}

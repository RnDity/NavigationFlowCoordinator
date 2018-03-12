//
//  MoviesListCoordinator.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 02/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation
import NavigationFlowCoordinator

class MoviesListCoordinator: NavigationFlowCoordinator {
    var connection: Connection

    var moviesListViewController: MoviesListViewController!

    override init() {
        self.connection = MockedConnection()
        super.init()
    }

    override func createMainViewController() -> UIViewController? {
        moviesListViewController = MoviesListViewController(connection: connection)
        moviesListViewController.flowDelegate = self
        return moviesListViewController
    }

    override func handle(flowEvent: FlowEvent) -> Bool {
        if flowEvent is MovieCreatedFlowEvent || flowEvent is MovieUpdatedFlowEvent {
            moviesListViewController.invalidateMovieData()
        }
        return false
    }
}

extension MoviesListCoordinator: MovieListFlowDelegate {
    func selectMovie(movie: MovieShortInfo) {
        if let movieId = movie.id {
//            start(childCoordinator: MovieDetailsCoordinator(connection: connection, movieId: movieId))
            start(childCoordinator: MovieDetailsCoordinator(connection: connection, movieId: movieId), with: .push)
        }
    }

    func addNewMoview() {
        start(childCoordinator: MovieCreateOrUpdateCoordinator(connection: connection, movieId: nil), with: .push)
    }

    func showAbout() {
//        push(viewController: AboutAppViewController())
        start(childCoordinator: AboutAppCoordinator(), with: .present)
    }
}

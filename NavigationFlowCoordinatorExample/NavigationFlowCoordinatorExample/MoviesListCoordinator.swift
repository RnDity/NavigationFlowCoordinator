//
//  MoviesListCoordinator.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
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
            start(childCoordinator: MovieDetailsCoordinator(connection: connection, movieId: movieId))
        }
    }
    
    func addNewMoview() {
        start(childCoordinator: MovieCreateOrUpdateCoordinator(connection: connection, movieId: nil))
    }
    
    func showAbout() {
        push(viewController: AboutAppViewController())
    }
}

//
//  Connection.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

protocol Connection {
    func getMovieShortInfo(completion: @escaping (([MovieShortInfo]? ,Error?) -> Void))
    func getMovie(withId id: String, completion: @escaping ((Movie? ,Error?) -> Void))
    func createMovie(movie: Movie, completion: @escaping ((Movie?, Error?) -> Void))
    func updateMovie(movie: Movie, completion: @escaping ((Movie?, Error?) -> Void))

}

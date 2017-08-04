//
//  Connection.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 02/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation

protocol Connection {
    func getMovieShortInfo(completion: @escaping (([MovieShortInfo]? ,Error?) -> Void))
    func getMovie(withId id: String, completion: @escaping ((Movie? ,Error?) -> Void))
    func createMovie(movie: Movie, completion: @escaping ((Movie?, Error?) -> Void))
    func updateMovie(movie: Movie, completion: @escaping ((Movie?, Error?) -> Void))

}

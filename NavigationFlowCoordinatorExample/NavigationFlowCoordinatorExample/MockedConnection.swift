//
//  MockedConnection.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 02/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation

class MockedConnection: Connection {
    let defaultDelay = 1000

    var movies = [Movie(id: "1", title: "The Godfather", isFavourite: false, genre: .Drama),
                  Movie(id: "2", title: "Die Hard", isFavourite: false, genre: .Action),
                  Movie(id: "3", title: "Forrest Gump", isFavourite: true, genre: .Comedy),
                  Movie(id: "4", title: "The Silence of the Lambs", isFavourite: false, genre: .Thriller),
                  Movie(id: "5", title: "Blade Runner", isFavourite: false, genre: .SciFi),
                  Movie(id: "6", title: "3:10 to Yuma", isFavourite: false, genre: .Western)]

    func getMovieShortInfo(completion: @escaping (([MovieShortInfo]?, Error?) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(defaultDelay)) { [weak self] in
            guard let movies = self?.movies else {
                completion(nil, ConnectionError())
                return
            }

            completion(movies.map {$0.toMovieShortInfo()}, nil)
        }
    }

    func createMovie(movie: Movie, completion: @escaping ((Movie?, Error?) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(defaultDelay)) { [weak self] in
            guard let movies = self?.movies else {
                completion(nil, ConnectionError())
                return
            }
            let ids = movies.map {$0.id}.flatMap {$0}.map {Int($0)!}
            if let lastId = ids.last {
                var newMovie = movie
                newMovie.id = String(lastId + 1)

                self?.movies.append(newMovie)

                completion(newMovie, nil)
            } else {
                completion(nil, ConnectionError())
            }
        }
    }

    func updateMovie(movie: Movie, completion: @escaping ((Movie?, Error?) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(defaultDelay)) { [weak self] in
            guard let movies = self?.movies else {
                completion(nil, ConnectionError())
                return
            }

            if let index = movies.index(where: {$0.id == movie.id}) {
                self?.movies.remove(at: index)
                self?.movies.insert(movie, at: index)

                completion(movie, nil)
            } else {
                completion(nil, ConnectionError())
            }

        }
    }

    func getMovie(withId id: String, completion: @escaping ((Movie?, Error?) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(defaultDelay)) { [weak self] in
            guard let movies = self?.movies else {
                completion(nil, ConnectionError())
                return
            }

            completion(movies.filter {$0.id == id}.first, nil)
        }
    }
}

class ConnectionError: Error {

}

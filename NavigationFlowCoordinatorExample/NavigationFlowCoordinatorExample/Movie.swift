//
//  Movie.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 02/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation

struct Movie {
    var id: String?
    var title: String
    var isFavourite: Bool
    var genre: MovieGenre
    
    func toMovieShortInfo() -> MovieShortInfo {
        return MovieShortInfo(id: id, title: title, isFavourite: isFavourite)
    }
}

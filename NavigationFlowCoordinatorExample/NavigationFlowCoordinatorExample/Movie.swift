//
//  Movie.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
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

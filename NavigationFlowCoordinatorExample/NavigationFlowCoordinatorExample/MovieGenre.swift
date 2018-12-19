//
//  MovieGenre.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

enum MovieGenre: String {
    case Comedy = "Comedy"
    case Thriller = "Thriller"
    case Drama = "Drama"
    case Action = "Action"
    case Western = "Western"
    case SciFi = "SciFi"
    
    static func allCases() -> [MovieGenre] {
        return [.Comedy, .Thriller, .Drama, .Action, .Western, .SciFi]
    }
}

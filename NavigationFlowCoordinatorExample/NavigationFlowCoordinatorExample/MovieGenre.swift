//
//  MovieGenre.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 02/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
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

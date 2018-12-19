//
//  MovieDetailsViewController.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailsFlowDelegate: class {
    func editMovie()
    
    func onMovieUpdated()
}

class MovieDetailsViewController: UIViewController {
    
    weak var flowDelegate: MovieDetailsFlowDelegate?
    
    var connection: Connection!
    var movieId: String!
    
    var movie: Movie?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var isFavouriteSwitch: UISwitch!
    
    
    public convenience init(connection: Connection, movieId: String){
        self.init(nibName: "MovieDetailsViewController", bundle: Bundle.main)
        self.connection = connection
        self.movieId = movieId
    }
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
        
        navigationItem.title = "Movie details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMovie))
        
        isFavouriteSwitch.addTarget(self, action: #selector(onGenreSwitchToggled), for: .valueChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataIfNeeded()
    }
    
    func fetchDataIfNeeded() {
        if movie == nil {
            fetchData()
        }
    }
    
    func fetchData() {
        showLoader()
        connection.getMovie(withId: movieId) { [weak self] movie, error in
            self?.hideLoader()
            if error == nil, let movie = movie {
                self?.movie = movie
                self?.updateView()
            }
        }
    }
    
    func updateView() {
        if let movie = movie {
            titleLabel.text = movie.title
            genreLabel.text = movie.genre.rawValue
            isFavouriteSwitch.isOn = movie.isFavourite
        }
    }
    
    @objc func editMovie() {
        flowDelegate?.editMovie()
    }
    
    @objc func onGenreSwitchToggled() {
        if var movie = movie {
            movie.isFavourite = isFavouriteSwitch.isOn
            updateMovie(movie: movie)
        }
    }
    
    func updateMovie(movie: Movie) {
        connection.updateMovie(movie: movie) { [weak self] movie, error in
            if error == nil, let movie = movie {
                self?.movie = movie
                self?.flowDelegate?.onMovieUpdated()
            }
        }
    }
    
    func invalidateMovieData() {
        movie = nil
    }
}

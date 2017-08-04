//
//  MovieCreateOrUpdateViewController.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 03/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCreateOrUpdateFlowDelegate: class {
    func onMovieUpdated()
    func onMovieCreated()
}

class MovieCreateOrUpdateViewController: UIViewController {
    
    weak var flowDelegate: MovieCreateOrUpdateFlowDelegate?
    
    var connection: Connection!
    var movieId: String?
    
    var movie: Movie?

    @IBOutlet weak var titleTextEdit: UITextField!
    @IBOutlet weak var genrePicker: UIPickerView!
    
    
    fileprivate lazy var genres: [String] = {
       return MovieGenre.allCases().map{$0.rawValue}
    }()
    
    override func viewDidLoad() {
        edgesForExtendedLayout = [] 
        
        navigationItem.title = movieId == nil ? "Create movie" : "Edit movie"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        genrePicker.dataSource = self
        genrePicker.delegate = self
        
        fetchData()
    }
    
    public convenience init(connection: Connection, movieId: String?){
        self.init(nibName: "MovieCreateOrUpdateViewController", bundle: Bundle.main)
        self.connection = connection
        self.movieId = movieId
    }
    
    func fetchData() {
        guard let movieId = movieId else {
            return
        }
        
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
            titleTextEdit.text = movie.title
            
            if let genreIndex = genres.index(of: movie.genre.rawValue) {
                genrePicker.selectRow(genreIndex, inComponent: 0, animated: true)
            }
        }
    }
    
    func save() {
        if var movie = movie {
            if let title = titleTextEdit.text, let genre = MovieGenre(rawValue: genres[genrePicker.selectedRow(inComponent: 0)]){
                movie.title = title
                movie.genre = genre
                
                updateMovie(movie: movie)
            }
        } else {
            createMovie()
        }
    }
    
    func updateMovie(movie: Movie) {
        showLoader()
        connection.updateMovie(movie: movie) { [weak self] movie, error in
            self?.hideLoader()
            if error == nil, let movie = movie {
                self?.movie = movie
                self?.flowDelegate?.onMovieUpdated()
            }
        }
    }
    
    func createMovie() {
        if let title = titleTextEdit.text, let genre = MovieGenre(rawValue: genres[genrePicker.selectedRow(inComponent: 0)]){
            let movie = Movie(id: nil, title: title, isFavourite: false, genre: genre)
            
            showLoader()
            connection.createMovie(movie: movie) { [weak self] movie, error in
                self?.hideLoader()
                if error == nil, let movie = movie {
                    self?.movie = movie
                    self?.flowDelegate?.onMovieCreated()
                }
            }
        }
    }
}

extension MovieCreateOrUpdateViewController: UIPickerViewDataSource {
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }

    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension MovieCreateOrUpdateViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row]
    }
}

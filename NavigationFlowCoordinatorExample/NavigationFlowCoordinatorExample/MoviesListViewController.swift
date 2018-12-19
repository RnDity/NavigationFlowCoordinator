//
//  MoviesListViewController.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

protocol MovieListFlowDelegate: class {
    func selectMovie(movie: MovieShortInfo)
    func addNewMoview()
    func showAbout()
}

class MoviesListViewController: UIViewController {
    
    weak var flowDelegate: MovieListFlowDelegate?
    
    var movies: [MovieShortInfo]?
    
    var connection: Connection!
    
    @IBOutlet weak var tableView: UITableView!
    
    public convenience init(connection: Connection){
        self.init(nibName: "MoviesListViewController", bundle: Bundle.main)
        self.connection = connection
    }
 
    override func viewDidLoad() {
        edgesForExtendedLayout = []
        
        navigationItem.title = "My movies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMovie))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "About app", style: .plain, target: self, action: #selector(showAbout))
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataIfNeeded()
    }
    
    func fetchDataIfNeeded() {
        if movies == nil {
            fetchData()
        }
    }
    
    func fetchData() {
        showLoader()
        connection.getMovieShortInfo{ [weak self] movies, error in
            self?.hideLoader()
            if error == nil, let movies = movies {
                self?.movies = movies
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func addNewMovie() {
        flowDelegate?.addNewMoview()
    }
    
    func invalidateMovieData() {
        movies = nil
    }
    
    @objc func showAbout() {
        flowDelegate?.showAbout()
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        }
        cell?.selectionStyle = .none
        
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let movie = movies?[indexPath.row]
        cell.textLabel?.text = movie?.title

        if movie?.isFavourite ?? false {
            let rightImageView = UIImageView()
            rightImageView.image = UIImage(named: "star")
            cell.accessoryView = rightImageView
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        } else {
            cell.accessoryView = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = movies?[indexPath.row] {
            flowDelegate?.selectMovie(movie: movie)
        }
    }
}

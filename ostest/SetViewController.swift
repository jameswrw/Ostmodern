//
//  SetViewController.swift
//  ostest
//
//  Created by Maninder Soor on 28/02/2017.
//  Copyright © 2017 Maninder Soor. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import RealmSwift
import SwiftyBeaver
import SwiftyJSON

/**
 Shows the list of Sets
 */
final class SetViewController : UIViewController {
    
    /// Table View
    @IBOutlet private weak var tblView : UITableView?
    
    /// Activity loader for the table vie
    @IBOutlet private weak var activity : UIActivityIndicatorView?
    
    /// Log
    let log = SwiftyBeaver.self
    
    // Movie database.
    fileprivate let database = Database.instance
    
    /**
     Setup the view
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Setup view for loading
        self.setupLoading(isLoading: true)
        
        /// Call to setup the data
        self.setupData()
        
        /// Setup the table data source.
        tblView?.dataSource = self
        
        /// Setup the table delegate.
        tblView?.delegate = self
        
        // Setup the navigation controller delegate.
        self.navigationController?.delegate = self
    }
    
    /**
     Setup loading
     
     - parameter isLoading
     */
    func setupLoading (isLoading : Bool) {
        
        isLoading ? self.activity?.startAnimating() : self.activity?.stopAnimating()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.activity?.alpha = isLoading ? 1.0 : 0.0
        }) { (_) in }
    }
    
    
    /**
     Sets up the data for the table view
     */
    func setupData () {
        let api = API.instance
        api.getSets { (success, sets) in
            // Update UI.
            self.setupLoading(isLoading: false)

            if sets != nil {
                for set in sets! {
                    let movie = Movie.initMovie(from: set)
                    self.database.add(movie: movie)
                }
            }
            self.tblView?.reloadData()
        }
    }
}


/**
 Table View datasource
 */
extension SetViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let movies = database.movies()
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Get the cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetViewCell.identifier) as? SetViewCell else {
            return UITableViewCell()
        }
        
        /// Set the data
        let movies = database.movies()
        let movie = movies[indexPath.row]
        
        /// Background image
        if let urlString = movie.imageURLs.first?.url {
            API.instance.retrieveImageURLFrom(url: urlString) { (imageURL) in
                cell.imgBackground?.af_setImage(withURL: imageURL) { (response) in
                    var image = response.value
                    if image == nil && response.data != nil {
                        image = UIImage(data: response.data!)
                        if image != nil {
                            cell.imgBackground?.image = image!
                        }
                    }
                }
            }
        }
        
        /// Title
        cell.lblTitle?.text = movie.title
        
        /// Description
        cell.txtDescription?.text = movie.summary

        /// Set favourite status.
        cell.btnFavourite?.setOn(movie.favourite, animated: false)
        
        /// Set id.
        cell.movieID = movie.uid
        
        /// Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// Default
        return 180.0
    }
}


/**
 Table view delegate
 */
extension SetViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        

        tableView.deselectRow(at: indexPath, animated: true)
        let details = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        navigationController?.pushViewController(details, animated: true)
        
        let movies = database.movies()
        let movie = movies[indexPath.row]
        details.movie = movie
    }
}

/**
 Navigation controller delegate
 */
extension SetViewController : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Show the navigation bar, unless it we are showing the root view, i.e. self.
        if viewController == self {
            navigationController.isNavigationBarHidden = true
        } else {
            navigationController.isNavigationBarHidden = false
        }
    }
}

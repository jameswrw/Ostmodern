//
//  DetailsViewController.swift
//  ostest
//
//  Created by JamesW on 19/11/2017.
//  Copyright © 2017 Maninder Soor. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet private weak var movieTitle: UILabel?
    @IBOutlet private weak var movieDescription: UITextView?
    @IBOutlet private weak var images: UITableView?
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        images?.dataSource = self
        images?.delegate = self
        
        if movie != nil {
            movieTitle?.text = movie!.title
            movieDescription?.text = movie!.setDescription
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Image table data source.
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie?.imageURLs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Get the cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailImageViewCell.identifier) as? DetailImageViewCell else {
            return UITableViewCell()
        }
        
        // Get the cell's background image.
        if movie != nil {
            let urlString = movie!.imageURLs[indexPath.row].url
            API.instance.retrieveImageURLFrom(url: urlString) { (imageURL) in
                cell.imgBackground?.af_setImage(withURL: imageURL) { (response) in
                    // Once we get the image, reszie the cell to fit.
                    let image = response.value
                    if image != nil {
                        var imageWidth = image!.size.width
                        var imageHeight = image!.size.height
                        let screenWidth = UIScreen.main.bounds.width
                        
                        // Make sure the image isn't wider than the screen.
                        if imageWidth > screenWidth {
                            imageWidth = screenWidth
                            imageHeight = imageHeight * screenWidth / imageWidth
                        }

                        cell.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
                    }
                }
            }
        }
        return cell
    }
}

// MARK: Image table delegate.
extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// Default - the cell will get resized once we have the image dimensions.
        return 180.0
    }
}

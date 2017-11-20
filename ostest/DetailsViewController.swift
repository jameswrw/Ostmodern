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
    
    // Dictionary of urls to images. Used to see if we've already downloaded an image.
    fileprivate var cellImages = [String : UIImage]()
    fileprivate let defaultImageHeight = 180.0 as CGFloat
    
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
            
            // If we've already downloaded the image, just set it to be the cell's background image.
            // Otherwise download and store it, then force the table to call heightForRowAt.
            let urlString = movie!.imageURLs[indexPath.row].url
            let image = cellImages[urlString]
            if image == nil {
                
                API.instance.retrieveImageURLFrom(url: urlString) { (imageURL) in
                    cell.imgBackground?.af_setImage(withURL: imageURL) { (response) in                        
                        var image = response.value
                        
                        // I came across instances where response.value was nil, but there was image
                        // data in response.data. So try that if we didn't get an image when looking
                        // at response.value.
                        if image == nil {
                            image = UIImage(data: response.data!)
                        }
                        
                        if image != nil {

                            self.cellImages[urlString] = image

                            // This forces the table to call heightForRowAt.
                            // Now we have the image, it can return the proper height.
                            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                        }
                    }
                }
            } else {
                cell.imgBackground?.image = image
            }
        }
        return cell
    }
}

// MARK: Image table delegate.
extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // First time in we won't have downloaded the image, so we can't return a good value.
        // cellForRowAt: will download the image, and cause this to be called again.
        // Second time round we have the image, so can return the proper height.
        guard let urlString = movie?.imageURLs[indexPath.row].url,
            let image = cellImages[urlString] else {return defaultImageHeight}
        
        // Return the height after sizing to fill the screen width, preserving the aspect ratio.
        return UIScreen.main.bounds.width / image.size.width * image.size.height
    }
}

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
    @IBOutlet private weak var image1: UIImageView?
    @IBOutlet private weak var image2: UIImageView?
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if movie != nil {
            movieTitle?.text = movie!.title
            movieDescription?.text = movie!.setDescription
            
            // This is a bit cheesy. Might want to progrmatically create image views instead.
            for index in 0...1 {

                var imageView: UIImageView?
                if index == 0 {
                    imageView = image1
                } else {
                    imageView = image2
                }
                
                if index < movie!.imageURLs.count {
                    let urlString = movie!.imageURLs[index].url
                    API.instance.retrieveImageURLFrom(url: urlString) { (imageURL) in
                        imageView?.af_setImage(withURL: imageURL) { (response) in
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

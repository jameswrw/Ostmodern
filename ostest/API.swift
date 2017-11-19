//
//  API.swift
//  ostest
//
//  Created by Maninder Soor on 28/02/2017.
//  Copyright © 2017 Maninder Soor. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyBeaver

/**
 The API Class connects to the Skylark API to access content and present it type safe structs
 */
class API {
    
    /// Singleton instance
    static let instance = API()
    
    /// Log
    let log = SwiftyBeaver.self
    
    /// The base URL
    let baseURL = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000"
    
    // For checking if the API request was successful.
    let kHTTPSuccess = 200
    
    /**
     Get sets
     */
    func getSets (completion : @escaping (_ isSuccess : Bool, _ set : [APISet]?) -> Void) {
        
        let apiString = "\(baseURL)/api/sets/"
        log.verbose("Getting sets with URL \(apiString)")
        
        /// Request
        Alamofire.request(apiString).responseJSON { response in
            
            var sets: [APISet]?
            defer {
                completion(sets != nil ? true : false, sets)
            }
            
            self.log.verbose("Response for getting sets \(response.response.debugDescription)")
            
            if let httpResponse = response.response {
                if httpResponse.statusCode == self.kHTTPSuccess {
                    // Perhaps value! is a bit fast and loose, but I'm assuming that an HTML 200 code means we're good to go...
                    let json = JSON(response.result.value!)
                    sets = APISet.parse(json)
                }
            }
        }
    }
    
    /**
     The image URLs in a Movie actually point to a block of json that contains the actual image URL.
     Return that URL via the completion handler.
     */
    func retrieveImageURLFrom(url: String, completion: @escaping (_ url: URL)->Void) {
        
        if let url = URL(string: baseURL + url) {
            Alamofire.request(url.absoluteString).responseJSON { response in
                
                if let httpResponse = response.response {
                    if httpResponse.statusCode == self.kHTTPSuccess {
                        // Perhaps value! is a bit fast and loose, but I'm assuming that an HTML 200 code means we're good to go...
                        let json = JSON(response.result.value!)
                        guard let imageURLString = json["url"].rawString(),
                            let imageURL = URL(string: imageURLString) else {return}
                        
                        completion(imageURL)
                    }
                }
            }
        }
    }
    
    /**
     Updates an APISet object from the /sets/ endpoint to a full formed APISet with correct images
     
     - parameter set: The APISet to convert
     - returns: APISet
     */
    func updateSet (set : APISet, completion : @escaping (_ isSuccess : Bool, _ set : APISet?) -> Void) {
        
        guard let apiString = set.imageURLs.first else {
            return
        }
        log.verbose("Getting image information with URL \(apiString)")
        
        
        /// Request
        Alamofire.request("\(self.baseURL)\(apiString)").responseJSON { response in
            
            self.log.verbose("Response for getting set image \(response.response.debugDescription)")
            
            if let result = response.result.value {
                let json = JSON(result)
                guard let url = json["url"].string else {
                    completion(false, nil)
                    return
                }
                
                let newSet = APISet(uid: set.uid, title: set.title, setDescription: set.setDescription, setDescriptionFormatted: set.setDescriptionFormatted, summary: set.summary, imageURLs: [url])
                completion(true, newSet)
                
            } else {
                completion(false, nil)
            }
        }
    }
}

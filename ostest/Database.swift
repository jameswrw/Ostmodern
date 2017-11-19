//
//  Database.swift
//  ostest
//
//  Created by Maninder Soor on 28/02/2017.
//  Copyright © 2017 Maninder Soor. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyBeaver

/**
 The Database class manages DB access including convenint methods for inserts, deletions and updates
 */
class Database {
    
    /// Static Singleton
    static let instance = Database()
    
    /// Log
    let log = SwiftyBeaver.self
    
    private let realm = try! Realm()
    
    func eraseAll() {
        realm.beginWrite()
        realm.deleteAll()
        try? realm.commitWrite()
    }
    
    func add(movie: Movie) {

        let movies = self.movies()
        let matches = movies.filter("uid == %@", movie.uid)
        
        // Don't add a movie if it's already in the database.
        if matches.count == 0 {
            try? realm.write {
                realm.add(movie)
            }
        }
    }
    
    func setFavouriteStatusFor(movieWithID uid: String, isFavourite favourite: Bool) {
        let movies = self.movies()
        let matches = movies.filter("uid == %@", uid)
        
        // uid is the primary key, so we should find exactly one thing.
        realm.beginWrite()
        matches[0].favourite = favourite
        try? realm.commitWrite()
    }
    
    func movies()->Results<Movie> {
        return realm.objects(Movie.self)
    }
}

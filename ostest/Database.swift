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
        try? realm.write {
            realm.add(movie, update: true)
        }
    }
    
    func movies()->Results<Movie> {
        return realm.objects(Movie.self)
    }
}

//
//  ostestTests.swift
//  ostestTests
//
//  Created by Maninder Soor on 27/02/2017.
//  Copyright © 2017 Maninder Soor. All rights reserved.
//

import XCTest
@testable import Ostmodern

class ostestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     Test the Database class.
     */
    func testDatabase() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let database = Database.instance
        database.eraseAll()

        let movie1 = Movie()
        movie1.uid = "Movie 1"
        movie1.title = "The Terminator"
        movie1.summary = "Robot mayhem"
        movie1.setDescription = "Arnie, robots, guns, explosions"
        
        let movie2 = Movie()
        movie2.uid = "Movie 2"
        movie2.title = "Terminator 2"
        movie2.summary = "More robot mayhem"
        movie2.setDescription = "Arnie, robots, guns, explosions. Again"
        
        // Should be an empty database.
        XCTAssertEqual(database.movies().count, 0)
        
        // Add a movie and confirm the database has an entry.
        database.add(movie: movie1)
        XCTAssertEqual(database.movies().count, 1)
        
        // Add another movie and confirm the database has two entries.
        database.add(movie: movie2)
        XCTAssertEqual(database.movies().count, 2)
        
        // Add a movie that we've already added and confirm the database still has two entries.
        database.add(movie: movie2)
        XCTAssertEqual(database.movies().count, 2)
        
        // Confirm we haven't favourited a movie.
        XCTAssertEqual(database.movies()[0].favourite, false)
        
        // Favourite it, and confirm the change.
        database.setFavouriteStatusFor(movieWithID: "Movie 1", isFavourite: true)
        XCTAssertEqual(database.movies()[0].favourite, true)

        // Empty the database, and confirm it's empty.
        database.eraseAll()
        XCTAssertEqual(database.movies().count, 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

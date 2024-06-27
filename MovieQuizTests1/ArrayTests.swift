//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 27.06.2024.
//

import XCTest

@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        
        let array = [1, 1, 2, 3, 5]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    
    func testGetValueOutRange() throws {
        
        let array = [1, 1, 2, 3, 5]
        
        let value = array[safe: 20]
        
        XCTAssertNil(value)
        
    }
}

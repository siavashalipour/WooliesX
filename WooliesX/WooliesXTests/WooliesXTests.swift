//
//  WooliesXTests.swift
//  WooliesXTests
//
//  Created by Siavash on 24/9/20.
//  Copyright © 2020 Siavash. All rights reserved.
//

import XCTest
@testable import WooliesX

class WooliesXTests: XCTestCase {

    private let vm = MainViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSorting() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results
        
        // test descending
        let mockDataA = "10 -23 years!"
        let mockDataB = "4 - years !"
        let result1 = vm.compare(first: mockDataA, second: mockDataB, isAscending: false)
        XCTAssertTrue(result1, "\(mockDataA) is bigger than \(mockDataB)")
        
        // test ascending
        let result2 = vm.compare(first: mockDataB, second: mockDataA, isAscending: true)
        XCTAssertTrue(result2, "\(mockDataB) is smaller than \(mockDataA)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

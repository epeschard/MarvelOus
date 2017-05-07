//
//  MarvelOusTests.swift
//  MarvelOusTests
//
//  Created by Eugène Peschard on 05/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import XCTest
import RealmSwift

@testable import MarvelOus

class TestCaseRealm: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Use an in-memory Realm identified by the name of the current test.
    // This ensures that each test can't accidentally access or modify the data
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
  }
}

class MarvelOusTests: TestCaseRealm {
  
  func testLoadLocalJSONtoRealm() {
    // given
    if let path = Bundle.main.path(forResource: "Comics", ofType: "json") {
      do {
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
          try Comic.create(from: jsonResult)
        }
      } catch { print(error.localizedDescription) }
    }
    
    // when
    let count = try! Realm().objects(Comic.self).count
    
    // then
    XCTAssertEqual(count, 10)
  }
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

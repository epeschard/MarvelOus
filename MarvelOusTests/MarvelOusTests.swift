//
//  MarvelOusTests.swift
//  MarvelOusTests
//
//  Created by Eugène Peschard on 05/05/2017.
//

import XCTest
import RealmSwift

@testable import MarvelOus

var sessionUnderTest: URLSession!
let realm = try! Realm()

class TestCaseRealm: XCTestCase {
  
  override func setUp() {
    super.setUp()
    sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
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
    let characterCount = realm.objects(Character.self).count
    let characterListCount = realm.objects(CharacterList.self).count
    let comicCount = realm.objects(Comic.self).count
    let comicSummaryCount = realm.objects(ComicSummary.self).count
    let creatorCount = realm.objects(Creator.self).count
    let creatorListCount = realm.objects(CreatorList.self).count
    let datesCount = realm.objects(Dates.self).count
    let imagesCount = realm.objects(Images.self).count
    let priceCount = realm.objects(Price.self).count
    let seriesCount = realm.objects(Series.self).count
    let textObjectCount = realm.objects(TextObject.self).count
    let thumbnailCount = realm.objects(Thumbnail.self).count
    let urlCount = realm.objects(Url.self).count
    
    // then
    XCTAssertEqual(characterCount, 8)
    XCTAssertEqual(characterListCount, 10)
    XCTAssertEqual(comicCount, 10)
    XCTAssertEqual(comicSummaryCount, 0)
    XCTAssertEqual(creatorCount, 22)
    XCTAssertEqual(creatorListCount, 10)
    XCTAssertEqual(datesCount, 31)
    XCTAssertEqual(imagesCount, 11)
    XCTAssertEqual(priceCount, 11)
    XCTAssertEqual(seriesCount, 6)
    XCTAssertEqual(textObjectCount, 10)
    XCTAssertEqual(thumbnailCount, 10)
    XCTAssertEqual(urlCount, 22)
  }
  
  // Asynchronous test: faster fail
  func testPhotoFetchCompletes() {
    // given
    let path = "http://i.annihil.us/u/prod/marvel/i/mg/3/40/5900b1d977e02"
//    let url = URL(string: "\(path)/standard_xlarge.jpg")!
    // store XCTestExpectation in promise
    let promise =  expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    
    // when
    if let url = URL(string: "\(path)/standard_xlarge.jpg") {
      let dataTask = sessionUnderTest.dataTask(with: url) {
        data, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        // to match the description
        promise.fulfill()
      }
      dataTask.resume()
    }
    // keep the test running until all expectations are fulfilled, or reach timeout
    waitForExpectations(timeout: 5, handler: nil)
    
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
  
  func testGetThumbnailData() {
    // given
    let thumbnail = Thumbnail()
    let path = "http://i.annihil.us/u/prod/marvel/i/mg/3/40/5900b1d977e02"
    // store XCTestExpectation in promise
    let promise =  expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    // when
    MarvelAPI().getData(for: thumbnail, from: path) {
      dataResponse in
      statusCode = dataResponse.response?.statusCode
      responseError = dataResponse.error
      // to match the description
      if dataResponse.data != nil {
        promise.fulfill()
      }
    }
    // keep the test running until all expectations are fulfilled, or reach timeout
    waitForExpectations(timeout: 5, handler: nil)
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
  
  func testJsonDownload() {
    // given
    // store XCTestExpectation in promise
    let promise =  expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    // when
    MarvelAPI().download(.comics, first: 100, startingFrom: 0) {
      dataResponse in
      statusCode = dataResponse.response?.statusCode
      responseError = dataResponse.error
      // to match the description
      if dataResponse.result.value is [String: Any] {
        promise.fulfill()
      }
    }
    // keep the test running until all expectations are fulfilled, or reach timeout
    waitForExpectations(timeout: 5, handler: nil)
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
  
  func testRemoteJsonFetchCompletes() {
    // given
    let path = "http://i.annihil.us/u/prod/marvel/i/mg/3/40/5900b1d977e02"
    //    let url = URL(string: "\(path)/standard_xlarge.jpg")!
    // store XCTestExpectation in promise
    let promise =  expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    
    // when
    if let url = URL(string: "\(path)/standard_xlarge.jpg") {
      let dataTask = sessionUnderTest.dataTask(with: url) {
        data, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        // to match the description
        promise.fulfill()
      }
      dataTask.resume()
    }
    // keep the test running until all expectations are fulfilled, or reach timeout
    waitForExpectations(timeout: 5, handler: nil)
    
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
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

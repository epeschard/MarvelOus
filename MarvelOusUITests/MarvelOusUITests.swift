//
//  MarvelOusUITests.swift
//  MarvelOusUITests
//
//  Created by Eugène Peschard on 05/05/2017.
//

import XCTest

class MarvelOusUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testSearch() {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    let app = XCUIApplication()
    app.tables.buttons["Comics"].tap()
    app.buttons["Comics"].tap()
    app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
    app.searchFields["Search"].tap()
    
    
  }
  
  func testDynamicText() {
    XCUIDevice.shared().orientation = .portrait
    XCUIDevice.shared().orientation = .portrait
    
    let app = XCUIApplication()
    let settingsElement = app.scrollViews["AppSwitcherScrollView"].otherElements["Settings"]
    settingsElement.tap()
    XCUIDevice.shared().orientation = .portrait
    
    let dynamictypetableTable = app.tables["DynamicTypeTable"]
    let slider = dynamictypetableTable.sliders["50 %"]
    slider.swipeRight()
    XCUIDevice.shared().orientation = .portrait
    
    let marvelousElement = app.otherElements["MarvelOus"]
    marvelousElement.tap()
    XCUIDevice.shared().orientation = .portrait
    XCUIDevice.shared().orientation = .portrait
    settingsElement.tap()
    XCUIDevice.shared().orientation = .portrait
    dynamictypetableTable.sliders["100 %"].swipeLeft()
    slider.tap()
    //TODO: Assert Font size change
    XCUIDevice.shared().orientation = .portrait
    marvelousElement.tap()
    XCUIDevice.shared().orientation = .portrait
    XCUIDevice.shared().orientation = .portrait
    settingsElement.tap()
    XCUIDevice.shared().orientation = .portrait
    dynamictypetableTable.sliders["0 %"].tap()
    XCUIDevice.shared().orientation = .portrait
    marvelousElement.tap()
    XCUIDevice.shared().orientation = .portrait
    XCUIDevice.shared().orientation = .faceUp
    //TODO: Assert Font size change
  }
  
  func testAttributionWithCardAnimation() {
    XCUIDevice.shared().orientation = .faceUp
    
    let app = XCUIApplication()
    app.navigationBars["Comics"].buttons["©"].tap()
    //TODO: Assert Card shown
    app.buttons["Close"].tap()
    //TODO: Assert Card dismissed
    XCUIDevice.shared().orientation = .portrait
    //TODO: Assert Card Animation
  }
  
  func testComicDetails() {
    XCUIApplication().tables.staticTexts["MARVEL FUTURE FIGHT: AN EYE ON THE FUTURE, presented by NETMARBLE (2017)"].tap()
    
  }
  
  func testComicDetailsPopOver() {
    
  }
  
}

//
//  FlickerUITests.swift
//  FlickerUITests
//
//  Created by Monica Pandey on 03/12/2021.
//

import XCTest

class FlickerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
  
// MARK: TabBarController Tests
  func testNavigateToSearchViewController() {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["Search"].tap()
    XCTAssertTrue(app.searchFields["Search photo here..."].exists)
  }
  
  func testNavigateHistoryViewController() {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["History"].tap()
    XCTAssertFalse(app.searchFields["Search photo here..."].exists)
  }
  
// MARK: Search ViewController Tests
  func testSearchBarCancelDismissesKeyboard() {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["Search"].tap()
    app.searchFields["Search photo here..."].tap()
    app.buttons["Cancel"].tap()
    XCTAssertEqual(app.keyboards.count, 0)
  }
  
  func testSearchBarCancelClearsText() {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["Search"].tap()
    app.searchFields["Search photo here..."].tap()
    
    let aKey = app.keyboards.keys["A"]
    aKey.tap()
    
    let bKey = app.keyboards.keys["b"]
    bKey.tap()
    
    let cKey = app.keyboards.keys["c"]
    cKey.tap()
    
    app.buttons["Cancel"].tap()
    
    XCTAssertEqual(app.searchFields["Search photo here..."].label, "Search photo here...")
  }
  
  func testSearchButtonDismissesKeyboard() {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["Search"].tap()
    app.searchFields["Search photo here..."].tap()
    app.keyboards.buttons["Search"].tap()
    print(app.keyboards.count)
    XCTAssertEqual(app.keyboards.count, 0)
  }
  
  func testSearchButtonDoesnotClearText() {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["Search"].tap()
    app.searchFields["Search photo here..."].tap()
    
    let aKey = app.keyboards.keys["A"]
    aKey.tap()
    
    let bKey = app.keyboards.keys["b"]
    bKey.tap()
    
    let cKey = app.keyboards.keys["c"]
    cKey.tap()
    
    app.keyboards.buttons["Search"].tap()
    
    XCTAssertEqual(app.searchFields["Search photo here..."].value as! String, "Abc")
  }
  
  
// MARK: History ViewController Tests
  func testTappingHistoryItemLoadsSearchVCWithSameQuery() {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["Search"].tap()
    app.searchFields["Search photo here..."].tap()
    
    let aKey = app.keyboards.keys["A"]
    aKey.tap()
    
    let bKey = app.keyboards.keys["b"]
    bKey.tap()
    
    let cKey = app.keyboards.keys["c"]
    cKey.tap()
    
    app.keyboards.buttons["Search"].tap()
    
    app.tabBars["Tab Bar"].buttons["History"].tap()
    
    app.tables.cells.element.tap()
    
    XCTAssertEqual(app.searchFields["Search photo here..."].value as! String, "Abc")
  }
}

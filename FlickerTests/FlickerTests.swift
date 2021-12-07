//
//  FlickerTests.swift
//  FlickerTests
//
//  Created by Monica Pandey on 03/12/2021.
//

import XCTest
@testable import Flicker

class FlickerTests: XCTestCase {
  var cacheManager: CacheManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      cacheManager = CacheManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
  
  func testSearchBlankQueryResult() async {
    do {
      async let result = try await SearchImageAPIService.searchImage(searchText: "")
      let asyncResult = try await result
      print(asyncResult)
    } catch {
      guard let e = error as? APIError else { return }
      
      XCTAssertTrue(e == APIError.SearchTextIsBlank)
    }
  }
  
  func testInvalidUrl() async {
    do {
      let _ = try await APIService.postMethod(urlString: "")
    } catch {
      guard let e = error as? APIError else { return }
      
      XCTAssertTrue(e == APIError.UnableToCreateURL)
      
    }
  }

}

//
//  MobileUsageTests.swift
//  MobileUsageTests
//
//  Created by Ananta Sjartuni on 5/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import XCTest
@testable import MobileUsage

class MobileUsageTests: XCTestCase {

    let jsonTest =
    """
        {
    "help": "https://data.gov.sg/api/3/action/help_show?name=datastore_search",
    "success": true,
    "result": {
        "resource_id": "a807b7ab-6cad-4aa6-87d0-e283a7353a0f",
        "fields": [
            {
                "type": "int4",
                "id": "_id"
            },
            {
                "type": "text",
                "id": "quarter"
            },
            {
                "type": "numeric",
                "id": "volume_of_mobile_data"
            }
        ],
        "records": [
            {
                "volume_of_mobile_data": "0.000384",
                "quarter": "2004-Q3",
                "_id": 1
            },
            {
                "volume_of_mobile_data": "0.000543",
                "quarter": "2004-Q4",
                "_id": 2
            },
            {
                "volume_of_mobile_data": "0.00062",
                "quarter": "2005-Q1",
                "_id": 3
            }
        ],
        "_links": {
            "start": "/api/action/datastore_search?limit=3&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f",
            "next": "/api/action/datastore_search?offset=3&limit=3&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        },
        "limit": 3,
        "total": 59
        }
    }
    """

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDecode() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let data = jsonTest.data(using: .utf8)
        let resultDecode = util.decode(data)
         XCTAssertNotNil(resultDecode, "Should not be nil")
         XCTAssertEqual(resultDecode?.result.records.count, 3)
    }
    
    func testArrayConversion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let data = jsonTest.data(using: .utf8)
        let resultDecode = util.decode(data)
        if let result = resultDecode {
            let yearlyArr = util.getYearlyArray(result)
            XCTAssertEqual(yearlyArr.count, 2)
        }
        XCTAssertNotNil(resultDecode, "Should not be nil")
    }

    
    func testMockSuccessfulResponse() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = DataProxy(session: session)
        
        // Create data and tell the session to always return it
        let data = Data(bytes: [0, 1, 0, 1])
        let header = ["Content-Type":"application/json"]
        let response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 400, httpVersion: nil, headerFields: header)!
        session.response = response
        session.data = data
        
        // Create a URL (using the file path API to avoid optionals)
        //let url = URL(fileURLWithPath: "url")
        
        // Perform the request and verify the result
        var result: FechError?
        manager.fetchData() { result = $1 }
        XCTAssertEqual(result,FechError.responseError )
    }

    // to handle mime type only support json
    func testMockHeaderResponse() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = DataProxy(session: session)
        
        // Create data and tell the session to always return it
        let data = jsonTest.data(using: .utf8)
        let header = ["Content-Type":"application/xml"]
        let response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 200, httpVersion: nil, headerFields: header)!
        session.response = response
        session.data = data
        
        // Create a URL (using the file path API to avoid optionals)
        //let url = URL(fileURLWithPath: "url")
        
        // Perform the request and verify the result
        var result: FechError?
        manager.fetchData() { result = $1 }
        XCTAssertEqual(result,FechError.wrongMimeType )
    }

    // test mock data with real json format
    func testMockData() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = DataProxy(session: session)
        
        // Create data and tell the session to always return it
        let data = jsonTest.data(using: .utf8)
        let header = ["Content-Type":"application/json"]
        let response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 200, httpVersion: nil, headerFields: header)!
        session.response = response
        session.data = data
        
        // Create a URL (using the file path API to avoid optionals)
        //let url = URL(fileURLWithPath: "url")
        
        // Perform the request and verify the result
        var result: Data?
        //var err:FechError?
        manager.fetchData() { result = $0; _ = $1 }
        let resultDecode = util.decode(result)
        XCTAssertNotNil(resultDecode, "Should not be nil")
        XCTAssertEqual(resultDecode?.result.records.count, 3)
    }

    func testMockViewModel() {
        // Setup our objects
        let session = URLSessionMock()
        let viewModel = ViewModel(session: session)
        
        // Create data and tell the session to always return it
        let data = jsonTest.data(using: .utf8)
        let header = ["Content-Type":"application/json"]
        let response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 200, httpVersion: nil, headerFields: header)!
        session.response = response
        session.data = data
        
        // Create a URL (using the file path API to avoid optionals)
        //let url = URL(fileURLWithPath: "url")
        
        // Perform the request and verify the result
        var result: Int?
        var err:FechError?
        viewModel.fetchData { result = $0; err = $1}
            
        XCTAssertEqual(result, 2)
        
        let item1 = viewModel.getItemAt(0)
        let item2 = viewModel.getItemAt(1)
        XCTAssertEqual(item1?.year, "2004")
        XCTAssertEqual(item2?.year, "2005")

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

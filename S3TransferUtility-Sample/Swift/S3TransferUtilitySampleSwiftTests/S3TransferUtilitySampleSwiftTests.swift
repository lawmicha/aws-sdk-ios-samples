//
//  S3TransferUtilitySampleSwiftTests.swift
//  S3TransferUtilitySampleSwiftTests
//
//  Created by Law, Michael on 8/12/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import XCTest

import S3TransferUtilitySampleSwift


class S3TransferUtilitySampleSwiftTests: XCTestCase {

    override func setUp() {
    
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUploadSuccess() {
        let plugin = AWSS3StoragePlugin()
        do {
            let config: Any = 1 // Not currently used. configuration is hardcoded
            try plugin.configure(using: config)
        } catch {
        }

        // upload
        var dataString = "1234567890"
        for _ in 1...5 {
            dataString += dataString
        }
        let testData = dataString.data(using: String.Encoding.utf8)!

        plugin.put(key: "testingKey3", data: testData, options: 1)
        
    }
    
    func testDownloadSuccess() {
        let plugin = AWSS3StoragePlugin()
        do {
            let config: Any = 1 // Not currently used. configuration is hardcoded
            try plugin.configure(using: config)
        } catch {
        }
        
        plugin.get(key: "testingKey3")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

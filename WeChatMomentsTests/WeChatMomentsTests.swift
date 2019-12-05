//
//  WeChatMomentsTests.swift
//  WeChatMomentsTests
//
//  Created by rainedAllNight on 2019/11/21.
//  Copyright © 2019 luowei. All rights reserved.
//

import XCTest
@testable import WeChatMoments

class WeChatMomentsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testApi() {
        let exceptation = self.expectation(description: "async request")
        WCHttpManager<ApiMonment, UserModel>.requestModel(.fetchUserProfileInfo, success: { (user) in
            XCTAssertNotNil(user)
            exceptation.fulfill()
        }) { (error) in
            
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTweetApi() {
        let exceptation = self.expectation(description: "async request")
        WCHttpManager<ApiMonment, TweetModel>.requestModelList(.fetchTweets, success: { (tweets) in
            XCTAssert(tweets.count > 0)
            exceptation.fulfill()
        }) { (error) in
            
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  OpeningLogicTests.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 07/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OpeningLogic.h"

@interface OpeningLogicTests : XCTestCase

@end

@implementation OpeningLogicTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidateEmail {

    NSString *email;
    
    email = @"sem@";
    XCTAssertTrue(![OpeningLogic validateEmail:email]);
    
    email = @"sem@i";
    XCTAssertTrue(![OpeningLogic validateEmail:email]);
    
    email = @"@.com";
    XCTAssertTrue(![OpeningLogic validateEmail:email]);
    
    email = @"sem@i.";
    XCTAssertTrue(![OpeningLogic validateEmail:email]);
    
    email = @"sem@i.c";
    XCTAssertTrue([OpeningLogic validateEmail:email]);
}

@end

//
//  NSNumberExpenseTrackerTests.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 07/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSNumber+ExpenseTracker.h"

@interface NSNumberExpenseTrackerTests : XCTestCase

@end

@implementation NSNumberExpenseTrackerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSplitNumber {
    
    NSNumber *num;
    NSArray *splittedNumber;
    NSString *expectedPart1, *expectedPart2;
    
    num = @12313.12;
    splittedNumber = [num splitNumber];
    expectedPart1 = @"12313";
    expectedPart2 = @"12";
    
    XCTAssertTrue(splittedNumber.count == 2);
    XCTAssertTrue([splittedNumber[0] isEqualToString:expectedPart1], @"Expected %@, result %@", expectedPart1, splittedNumber[0]);
    XCTAssertTrue([splittedNumber[1] isEqualToString:expectedPart2], @"Expected %@, result %@", expectedPart2, splittedNumber[1]);
    
    num = @1.2;
    splittedNumber = [num splitNumber];
    expectedPart1 = @"1";
    expectedPart2 = @"20";
    
    XCTAssertTrue(splittedNumber.count == 2);
    XCTAssertTrue([splittedNumber[0] isEqualToString:expectedPart1], @"Expected %@, result %@", expectedPart1, splittedNumber[0]);
    XCTAssertTrue([splittedNumber[1] isEqualToString:expectedPart2], @"Expected %@, result %@", expectedPart2, splittedNumber[1]);
    
    num = @1;
    splittedNumber = [num splitNumber];
    expectedPart1 = @"1";
    expectedPart2 = @"00";
    
    XCTAssertTrue(splittedNumber.count == 2);
    XCTAssertTrue([splittedNumber[0] isEqualToString:expectedPart1], @"Expected %@, result %@", expectedPart1, splittedNumber[0]);
    XCTAssertTrue([splittedNumber[1] isEqualToString:expectedPart2], @"Expected %@, result %@", expectedPart2, splittedNumber[1]);
}

@end

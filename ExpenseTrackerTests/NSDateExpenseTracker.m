//
//  NSDateExpenseTracker.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+ExpenseTracker.h"

@interface NSDateExpenseTracker : XCTestCase

@end

@implementation NSDateExpenseTracker

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWeekDifferenceWithDate{
    
    NSDateComponents *comps;
    NSDate *date1, *date2;
    NSInteger result, expectedResult;
    
    //same month
    comps = [[NSDateComponents alloc] init];
    [comps setDay:28];
    [comps setMonth:4];
    [comps setYear:2016];
    date1 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:4];
    [comps setYear:2016];
    date2 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    result = [date1 weekDifferenceWithDate:date2];
    expectedResult = 4;
    XCTAssertTrue(result == expectedResult, @"result: %ld, expected %ld", (long)result, (long)expectedResult);
    
    //different month
    comps = [[NSDateComponents alloc] init];
    [comps setDay:2];
    [comps setMonth:4];
    [comps setYear:2016];
    date1 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:17];
    [comps setMonth:2];
    [comps setYear:2016];
    date2 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    result = [date1 weekDifferenceWithDate:date2];
    expectedResult = 6;
    XCTAssertTrue(result == expectedResult, @"result: %ld, expected %ld", (long)result, (long)expectedResult);
    
    //different year
    comps = [[NSDateComponents alloc] init];
    [comps setDay:27];
    [comps setMonth:5];
    [comps setYear:2016];
    date1 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:2];
    [comps setYear:2015];
    date2 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    result = [date1 weekDifferenceWithDate:date2];
    expectedResult = 70;
    XCTAssertTrue(result == expectedResult, @"result: %ld, expected %ld", (long)result, (long)expectedResult);
    
}


- (void)testMonthDifferenceWithDate{
    
    NSDateComponents *comps;
    NSDate *date1, *date2;
    NSInteger result, expectedResult;
    
    //same month
    comps = [[NSDateComponents alloc] init];
    [comps setDay:3];
    [comps setMonth:5];
    [comps setYear:2016];
    date1 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:2];
    [comps setMonth:4];
    [comps setYear:2016];
    date2 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    result = [date1 monthDifferenceWithDate:date2];
    expectedResult = 1;
    XCTAssertTrue(result == expectedResult, @"result: %ld, expected %ld", (long)result, (long)expectedResult);
    
    //different month
    comps = [[NSDateComponents alloc] init];
    [comps setDay:2];
    [comps setMonth:4];
    [comps setYear:2016];
    date1 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:17];
    [comps setMonth:2];
    [comps setYear:2016];
    date2 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    result = [date1 monthDifferenceWithDate:date2];
    expectedResult = 2;
    XCTAssertTrue(result == expectedResult, @"result: %ld, expected %ld", (long)result, (long)expectedResult);
    
    //different year
    comps = [[NSDateComponents alloc] init];
    [comps setDay:27];
    [comps setMonth:2];
    [comps setYear:2016];
    date1 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:17];
    [comps setMonth:2];
    [comps setYear:2015];
    date2 = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    result = [date1 monthDifferenceWithDate:date2];
    expectedResult = 12;
    XCTAssertTrue(result == expectedResult, @"result: %ld, expected %ld", (long)result, (long)expectedResult);
    
}

@end

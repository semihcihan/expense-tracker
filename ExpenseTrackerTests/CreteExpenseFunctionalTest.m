//
//  CreteExpenseFunctionalTest.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 08/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RestNetworkManager.h"

@interface CreteExpenseFunctionalTest : XCTestCase

@end

@implementation CreteExpenseFunctionalTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginAndGetCurrentUsersExpenses {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Creating new expense works!"];
    
    [[RestNetworkManager sharedInstance] loginWithUsername:@"se@i.co"
                                                  password:@"22323333"
                                              successBlock:^(NSString *sessionToken)
    {
        [[RestNetworkManager sharedInstance] getCurrentUserObjectIdWithSessionToken:sessionToken
                                                                       successBlock:^(NSString *userObjectId)
        {
            
            [[RestNetworkManager sharedInstance] getExpensesOfUserWithObjectId:userObjectId
                                                                  successBlock:^(NSArray *result)
            {
                [expectation fulfill];
            }
                                                                  failureBlock:^(NSError *error)
            {
                NSLog(@"error: %@", [error localizedDescription]);
            }];
            
        }
                                                                       failureBlock:^(NSError *error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
        }];
        
        
    }
                                              failureBlock:^(NSError *error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    }];
    
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error)
    {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end

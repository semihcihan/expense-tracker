//
//  ExpenseLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseLogic.h"

@implementation ExpenseLogic

- (void)getExpensesWithSuccessBlock:(void (^)(NSArray *))successBlock
                       failureBlock:(FailureBlock)failureBlock {
    
    [[NetworkManager sharedInstance] getExpensesOfUser:[NetworkManager currentUser]
                                          successBlock:^(NSArray *expenses)
    {
        self.expenses = expenses;
        successBlock(expenses);
    }
                                          failureBlock:^(NSString *error)
    {
        failureBlock(error);
    }];
}

@end

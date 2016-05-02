//
//  ExpenseLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseLogic.h"

@interface ExpenseLogic ()

@property (strong, nonatomic) NSArray *allExpenses;

@end

@implementation ExpenseLogic

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shownExpenses = @[].mutableCopy;
    }
    return self;
}

- (void)getExpensesWithSuccessBlock:(void (^)(NSArray *))successBlock
                       failureBlock:(FailureBlock)failureBlock {
    
    [[NetworkManager sharedInstance] getExpensesOfUser:[NetworkManager currentUser]
                                          successBlock:^(NSArray *expenses)
    {
        self.allExpenses = expenses;
        [self.shownExpenses addObjectsFromArray:self.allExpenses];
        successBlock(expenses);
    }
                                          failureBlock:^(NSString *error)
    {
        failureBlock(error);
    }];
}

@end

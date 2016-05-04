//
//  ExpenseDetailLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 04/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseDetailLogic.h"

@implementation ExpenseDetailLogic

- (void)saveChangesOnExpenseWithSuccessBlock:(void (^)(void))successBlock failureBlock:(void (^)(NSString *))failureBlock
{
    [self.expense saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (succeeded)
        {
            successBlock();
        }
        else
        {
            failureBlock([error localizedDescription]);
        }
    }];
}

@end

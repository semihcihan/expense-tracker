//
//  ExpenseDetailLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 04/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseDetailLogic.h"
#import "NetworkManager.h"

@implementation ExpenseDetailLogic

- (void)saveChangesOnExpenseWithSuccessBlock:(void (^)(void))successBlock
                                failureBlock:(void (^)(NSString *))failureBlock
{
    
    [NetworkManager saveChangesOnExpense:self.expense
                                  ofUser:self.user
                            successBlock:^
    {
        successBlock();
    }
                            failureBlock:^(NSString *error)
    {
        failureBlock(error);
    }];
}

- (void)deleteExpenseWithSuccessBlock:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSString *))failureBlock {
    
    [NetworkManager deleteExpense:self.expense
                     successBlock:^
     {
         successBlock();
     }
                     failureBlock:^(NSString *error)
     {
         failureBlock(error);
     }];
}

@end

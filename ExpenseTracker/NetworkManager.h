//
//  NetworkManager.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Expense.h"

@interface NetworkManager : NSObject

typedef void (^FailureBlock)(NSString *error);

+ (PFUser *)currentUser;

+ (void)logout;

+ (instancetype)sharedInstance;

+ (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
           successBlock:(void (^)(PFUser *))successBlock
           failureBlock:(FailureBlock)failureBlock;

+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
          successBlock:(void (^)(PFUser *))successBlock
          failureBlock:(FailureBlock)failureBlock;

+ (void)getExpensesOfUser:(PFUser *)user
             successBlock:(void (^)(NSArray *expenses))successBlock
             failureBlock:(FailureBlock)failureBlock;

+ (void)saveChangesOnExpense:(Expense *)expense
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSString *))failureBlock;

+ (void)deleteExpense:(Expense *)expense
         successBlock:(void (^)(void))successBlock
         failureBlock:(void (^)(NSString *))failureBlock;


@end

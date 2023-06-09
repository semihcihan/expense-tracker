//
//  ExpenseDetailLogic.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 04/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"

@interface ExpenseDetailLogic : NSObject

@property (strong, nonatomic) Expense *expense;
@property (strong, nonatomic) PFUser *user;

- (void)saveChangesOnExpenseWithSuccessBlock:(void (^) (void))successBlock
                                failureBlock:(void (^) (NSString *error))failureBlock;

- (void)deleteExpenseWithSuccessBlock:(void (^) (void))successBlock
                         failureBlock:(void (^) (NSString *error))failureBlock;

+ (NSNumber *)amountNumberWithIntegerPartString:(NSString *)integerPart
                              decimalPartString:(NSString *)decimalPart;

@end

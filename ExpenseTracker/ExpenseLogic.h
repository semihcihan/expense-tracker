//
//  ExpenseLogic.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface ExpenseLogic : NSObject

@property (strong, nonatomic) NSMutableArray *shownExpenses;

- (void)getExpensesWithSuccessBlock:(void (^)(NSArray *expenses))successBlock
                       failureBlock:(FailureBlock)failureBlock;


@end

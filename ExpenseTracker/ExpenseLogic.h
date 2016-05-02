//
//  ExpenseLogic.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

typedef NS_ENUM(NSUInteger, SortingMethod) {
    SortingMethodDate,
    SortingMethodAmount
};

@interface ExpenseLogic : NSObject

@property (strong, nonatomic) NSMutableArray *shownExpenses;

- (void)getExpensesWithSuccessBlock:(void (^)(NSArray *expenses))successBlock
                       failureBlock:(FailureBlock)failureBlock;

- (void)filterExpenseWithKeyword:(NSString *)keyword
              amountsGreaterThan:(NSNumber *)amount
                   inRecentWeeks:(NSInteger)weeks
                   sortingMethod:(SortingMethod)sortingMethod;

- (void)sortExpenses:(SortingMethod)sortingMethod;

@end

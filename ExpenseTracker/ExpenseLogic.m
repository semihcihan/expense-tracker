//
//  ExpenseLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseLogic.h"
#import "Expense.h"
#import "NSDate+ExpenseTracker.h"

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

- (void)filterExpenseWithKeyword:(NSString *)keyword
              amountsGreaterThan:(NSNumber *)amount
                   inRecentWeeks:(NSInteger)weeks
                   sortingMethod:(SortingMethod)sortingMethod {
    
    self.shownExpenses = [self filterExpenses:self.allExpenses
                                      keyword:keyword
                           amountsGreaterThan:amount
                                inRecentWeeks:weeks
                                sortingMethod:sortingMethod].mutableCopy;
}

- (void)sortExpenses:(SortingMethod)sortingMethod {
    self.shownExpenses = [self sortExpenses:self.shownExpenses
                              sortingMethod:sortingMethod].mutableCopy;
}

- (NSArray *)filterExpenses:(NSArray *)expenses
                    keyword:(NSString *)keyword
         amountsGreaterThan:(NSNumber *)amount
              inRecentWeeks:(NSInteger)weeks
              sortingMethod:(SortingMethod)sortingMethod {
    
    NSMutableArray *results = @[].mutableCopy;
    
    NSString *keywordLowercase = keyword.lowercaseString;
    for (Expense *expense in expenses)
    {
        if ((keyword.length == 0 || [expense.description.lowercaseString containsString:keywordLowercase] || [expense.comment.lowercaseString containsString:keywordLowercase])
            && [expense.amount compare:amount] != NSOrderedAscending
            && [self isDateWithinRecentWeeks:expense.date weeks:weeks])
        {
            [results addObject:expense];
        }
    }
    
    return [self sortExpenses:results
                sortingMethod:sortingMethod];
}

- (NSArray *)sortExpenses:(NSArray *)expenses sortingMethod:(SortingMethod)sortingMethod {
    
    if (sortingMethod == SortingMethodAmount)
    {
        NSArray *sortedArray;
        sortedArray = [expenses sortedArrayUsingComparator:^NSComparisonResult(Expense *a, Expense *b) {
            return [a.amount compare:b.amount] == NSOrderedAscending;
        }];
        return sortedArray;
    }
    else
    {
        NSArray *sortedArray;
        sortedArray = [expenses sortedArrayUsingComparator:^NSComparisonResult(Expense *a, Expense *b) {
            return [a.date compare:b.date] == NSOrderedAscending;
        }];
        return sortedArray;
    }
}

// amount is in weeks but if it's bigger than 3 weeks it is treated as months (e.g. 8 weeks 2 months)
- (BOOL)isDateWithinRecentWeeks:(NSDate *)date weeks:(NSInteger)weeks {
    
    if (weeks == -1)
    {
        return YES;
    }
    
    if (weeks <= 3)
    {
        return [[NSDate date] weekDifferenceWithDate:date] <= weeks - 1;
    }
    else
    {
        return [[NSDate date] monthDifferenceWithDate:date] <= (weeks / 4) - 1;
    }
}

@end

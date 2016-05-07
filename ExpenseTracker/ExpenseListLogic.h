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

@interface ExpenseListLogic : NSObject

@property (strong, nonatomic) PFUser *user;

@property (strong, nonatomic, readonly) NSMutableArray *shownExpenses;
@property (strong, nonatomic, readonly) NSMutableArray *shownExpensesPerWeek;

- (void)getExpensesWithSuccessBlock:(void (^)(NSArray *expenses))successBlock
                       failureBlock:(FailureBlock)failureBlock;

- (void)filterExpenseWithKeyword:(NSString *)keyword
              amountsGreaterThan:(NSNumber *)amount
                   inRecentWeeks:(NSInteger)weeks
                   sortingMethod:(SortingMethod)sortingMethod;

- (void)saveFilterAmountSliderValue:(CGFloat)amountSliderValue
                    dateSliderValue:(CGFloat)dateSliderValue
                   sortSegmentValue:(NSInteger)sortSegmentValue;

- (NSNumber *)totalExpense;
- (NSNumber *)totalAmountOfWeek:(NSInteger)week;
- (void)sortExpenses:(SortingMethod)sortingMethod;

+ (void)logout;

+ (CGFloat)getDateSliderValue;
+ (CGFloat)getAmountSliderValue;
+ (NSInteger)getSortSegmentValue;

+ (void)changeLocaleForCurrency:(NSString *)currency;

- (NSString *)currencyStringRepresentationOfAmount:(NSNumber *)amount;
- (NSString *)currencyStringRepresentationWithoutDecimalsOfAmount:(NSNumber *)amount;

@end

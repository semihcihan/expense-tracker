//
//  ExpenseLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseListLogic.h"
#import "Expense.h"
#import "NSDate+ExpenseTracker.h"
#import "NSLocale+ExpenseTracker.h"

@interface ExpenseListLogic ()

@property (strong, nonatomic) NSMutableArray *shownExpenses;
@property (strong, nonatomic) NSMutableArray *shownExpensesPerWeek;
@property (strong, nonatomic) NSArray *allExpenses;

@end

@implementation ExpenseListLogic

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shownExpenses = @[].mutableCopy;
    }
    return self;
}

+ (void)logout {
    [NetworkManager logout];
    
    //clear user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)getExpensesWithSuccessBlock:(void (^)(NSArray *))successBlock
                       failureBlock:(FailureBlock)failureBlock {
    
    [NetworkManager getExpensesOfUser:[NetworkManager currentUser]
                         successBlock:^(NSArray *expenses)
    {
        self.allExpenses = expenses;
        [self.shownExpenses removeAllObjects];
        [self.shownExpenses addObjectsFromArray:self.allExpenses];
        successBlock(expenses);
    }
                         failureBlock:^(NSString *error)
    {
        failureBlock(error);
    }];
}

- (NSNumber *)totalExpense {
    
    CGFloat total = 0.f;
    for (Expense *expense in self.shownExpenses)
    {
        total += expense.amount.floatValue;
    }
    
    return @(total);
}

- (NSNumber *)totalAmountOfWeek:(NSInteger)week {
    
    CGFloat total = 0.f;
    for (Expense *expense in self.shownExpensesPerWeek[week])
    {
        total += expense.amount.floatValue;
    }
    
    return @(total);
}

- (void)filterExpenseWithKeyword:(NSString *)keyword
              amountsGreaterThan:(NSNumber *)amount
                   inRecentWeeks:(NSInteger)weeks
                   sortingMethod:(SortingMethod)sortingMethod {
    
    self.shownExpenses = [ExpenseListLogic filterExpenses:self.allExpenses
                                                  keyword:keyword
                                       amountsGreaterThan:amount
                                            inRecentWeeks:weeks
                                            sortingMethod:sortingMethod].mutableCopy;
    
    if (sortingMethod == SortingMethodDate) {
        self.shownExpensesPerWeek = [ExpenseListLogic expensesPerWeek:self.shownExpenses].mutableCopy;
    }
}

- (void)sortExpenses:(SortingMethod)sortingMethod {
    self.shownExpenses = [ExpenseListLogic sortExpenses:self.shownExpenses
                                          sortingMethod:sortingMethod].mutableCopy;
    
    if (sortingMethod == SortingMethodDate) {
        self.shownExpensesPerWeek = [ExpenseListLogic expensesPerWeek:self.shownExpenses].mutableCopy;
    }
}

- (void)saveFilterAmountSliderValue:(CGFloat)amountSliderValue
                    dateSliderValue:(CGFloat)dateSliderValue
                   sortSegmentValue:(NSInteger)sortSegmentValue {

    [ExpenseListLogic saveAmountSliderValue:@(amountSliderValue)];
    [ExpenseListLogic saveDateSliderValue:@(dateSliderValue)];
    [ExpenseListLogic saveSortSegmentValue:@(sortSegmentValue)];
}

#pragma mark - NSUserDefaults

+ (void)saveDateSliderValue:(NSNumber *)value {
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"ETDateSliderValue"];
}

+ (void)saveAmountSliderValue:(NSNumber *)value {
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"ETAmountSliderValue"];
}

+ (void)saveSortSegmentValue:(NSNumber *)value {
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"ETSortSegmentValue"];
}

+ (CGFloat)getDateSliderValue {
    
    NSNumber *dateSliderValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"ETDateSliderValue"];
    
    return (dateSliderValue != nil) ? dateSliderValue.floatValue : 0.f;
}

+ (CGFloat)getAmountSliderValue {
    
    NSNumber *amountSliderValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"ETAmountSliderValue"];

    return (amountSliderValue != nil) ? amountSliderValue.floatValue : 0.f;
}

+ (NSInteger)getSortSegmentValue {
    
    NSNumber *sortSegmentValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"ETSortSegmentValue"];
    
    return (sortSegmentValue != nil) ? sortSegmentValue.integerValue : 0;
}

+ (void)changeLocaleForCurrency:(NSString *)currency {
    if ([currency isEqualToString:@"Phone's Currency"])
    {
        [NSLocale cleanExpenseTrackerLocale];
    }
    else if([currency isEqualToString:@"$"])
    {
        [NSLocale setExpenseTrackerLocaleWithIdentifier:@"en_US"];
    }
    else if([currency isEqualToString:@"€"])
    {
        [NSLocale setExpenseTrackerLocaleWithIdentifier:@"de_DE"];
    }
    else if([currency isEqualToString:@"£"])
    {
        [NSLocale setExpenseTrackerLocaleWithIdentifier:@"en_GB"];
    }
    else if([currency isEqualToString:@"₺"])
    {
        [NSLocale setExpenseTrackerLocaleWithIdentifier:@"tr_TR"];
    }
}

#pragma mark - Helpers


+ (NSArray *)filterExpenses:(NSArray *)expenses
                    keyword:(NSString *)keyword
         amountsGreaterThan:(NSNumber *)amount
              inRecentWeeks:(NSInteger)weeks
              sortingMethod:(SortingMethod)sortingMethod {
    
    NSMutableArray *results = @[].mutableCopy;
    
    NSString *keywordLowercase = keyword.lowercaseString;
    for (Expense *expense in expenses)
    {
        if ((keyword.length == 0 || [expense.expenseDescription.lowercaseString containsString:keywordLowercase] || [expense.comment.lowercaseString containsString:keywordLowercase])
            && [expense.amount compare:amount] != NSOrderedAscending
            && [self isDateWithinRecentWeeks:expense.date weeks:weeks])
        {
            [results addObject:expense];
        }
    }
    
    return [ExpenseListLogic sortExpenses:results
                sortingMethod:sortingMethod];
}

+ (NSArray *)sortExpenses:(NSArray *)expenses sortingMethod:(SortingMethod)sortingMethod {
    
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
+ (BOOL)isDateWithinRecentWeeks:(NSDate *)date weeks:(NSInteger)weeks {
    
    // if input is -1, no date filtering
    if (weeks == -1)
    {
        return YES;
    }
    
    // - 1 beacuse weeks 1 means this weak, so the difference should be 0
    if (weeks <= 3)
    {
        return [[NSDate date] weekDifferenceWithDate:date] <= weeks - 1;
    }
    else
    {
        return [[NSDate date] monthDifferenceWithDate:date] <= (weeks / 4) - 1;
    }
}

+ (NSArray *)expensesPerWeek:(NSArray *)expenses {
    
    NSMutableArray *weeklyExpenses = @[].mutableCopy;
    NSMutableArray *weekKeys = @[].mutableCopy;
    
    for (Expense *expense in expenses) {
        NSDateComponents *weekComponents = [expense.date weekOfYearAndYearComponents];
        NSString *weekKey = [NSString stringWithFormat:@"%ld %ld", (long)weekComponents.year, (long)weekComponents.weekOfYear];
        NSInteger weeklyExpenseLocation = [weekKeys indexOfObject:weekKey];
        if (weeklyExpenseLocation != NSNotFound)
        {
            [weeklyExpenses[weeklyExpenseLocation] addObject:expense];
        }
        else
        {
            [weekKeys addObject:weekKey];
            [weeklyExpenses addObject:@[expense].mutableCopy];
        }
    }
    
    return weeklyExpenses;
}

@end

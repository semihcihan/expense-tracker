//
//  NSLocale+ExpenseTracker.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 03/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (ExpenseTracker)

+ (NSLocale *)expenseTrackerLocale;
+ (void)setExpenseTrackerLocaleWithIdentifier:(NSString *)localeIdentifier;
+ (void)cleanExpenseTrackerLocale;

@end

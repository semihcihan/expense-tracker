//
//  NSLocale+ExpenseTracker.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 03/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NSLocale+ExpenseTracker.h"

@implementation NSLocale (ExpenseTracker)

+ (NSLocale *)expenseTrackerLocale {
    NSString *locaelIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpenseTrackerLocaleIdentifier"];
    return (locaelIdentifier != nil) ? [NSLocale localeWithLocaleIdentifier:locaelIdentifier] : [NSLocale currentLocale];
}

+ (void)setExpenseTrackerLocaleWithIdentifier:(NSString *)localeIdentifier {
    [[NSUserDefaults standardUserDefaults] setObject:localeIdentifier forKey:@"ExpenseTrackerLocaleIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)cleanExpenseTrackerLocale {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ExpenseTrackerLocaleIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

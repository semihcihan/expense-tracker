//
//  NSString+ExpenseTracker.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NSString+ExpenseTracker.h"
#import "NSLocale+ExpenseTracker.h"

@implementation NSString (ExpenseTracker)

+ (NSString *)currencySymbol {
    
    NSString *symbol = [[NSLocale expenseTrackerLocale] objectForKey:NSLocaleCurrencySymbol];
    return symbol;
}

+ (NSString *)percentSymbol {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale expenseTrackerLocale];
    return numberFormatter.decimalSeparator;
}

@end

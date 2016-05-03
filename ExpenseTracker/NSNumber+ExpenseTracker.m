//
//  NSNumber+ExpenseTracker.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NSNumber+ExpenseTracker.h"
#import "NSLocale+ExpenseTracker.h"

@implementation NSNumber (ExpenseTracker)

- (NSString *)currencyStringRepresentation {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale expenseTrackerLocale];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *numberAsString = [numberFormatter stringFromNumber:self];
    return numberAsString;
}

- (NSString *)currencyStringRepresentationWithoutDecimals {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale expenseTrackerLocale];
    numberFormatter.maximumFractionDigits = 0;
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *numberAsString = [numberFormatter stringFromNumber:self];
    return numberAsString;
}

@end

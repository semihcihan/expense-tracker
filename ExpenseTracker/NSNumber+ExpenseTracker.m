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

- (NSString *)currencyStringRepresentationShowCurrencySymbol:(BOOL)showCurrencySymbol {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale expenseTrackerLocale];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    if (!showCurrencySymbol)
    {
        [numberFormatter setCurrencySymbol:@""];
    }
    NSString *numberAsString = [numberFormatter stringFromNumber:self];
    return numberAsString;
}

- (NSArray *)splitNumber {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale expenseTrackerLocale];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.maximumFractionDigits = 2;
    numberFormatter.minimumFractionDigits = 2;
    [numberFormatter setUsesGroupingSeparator:NO];
    [numberFormatter setCurrencySymbol:@""];
    NSString *numberAsString = [numberFormatter stringFromNumber:self];
    NSArray *components = [numberAsString componentsSeparatedByString:@","];
    if (components.count == 2)
    {
        return components;
    }
    else
    {
        return [numberAsString componentsSeparatedByString:@"."];
    }
}

- (NSString *)currencyStringRepresentationWithoutDecimalsShowCurrencySymbol:(BOOL)showCurrencySymbol {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale expenseTrackerLocale];
    numberFormatter.maximumFractionDigits = 0;
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    if (!showCurrencySymbol)
    {
        [numberFormatter setCurrencySymbol:@""];
    }
    NSString *numberAsString = [numberFormatter stringFromNumber:self];
    return numberAsString;
}

@end

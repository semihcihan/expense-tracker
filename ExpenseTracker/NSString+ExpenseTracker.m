//
//  NSString+ExpenseTracker.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NSString+ExpenseTracker.h"

@implementation NSString (ExpenseTracker)

+ (NSString *)currencySymbol {
    
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    return symbol;
}

@end

//
//  NSNumber+ExpenseTracker.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (ExpenseTracker)

- (NSString *)currencyStringRepresentationShowCurrencySymbol:(BOOL)showCurrencySymbol;
- (NSString *)currencyStringRepresentationWithoutDecimalsShowCurrencySymbol:(BOOL)showCurrencySymbol;
- (NSArray *)splitNumber;

@end

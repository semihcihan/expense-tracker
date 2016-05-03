//
//  NSDate+ExpenseTracker.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ExpenseTracker)

- (NSString *)localeDateString;
- (NSInteger)weekDifferenceWithDate:(NSDate *)date;
- (NSInteger)monthDifferenceWithDate:(NSDate *)date;
- (NSDateComponents *)weekOfYearAndYearComponents;

@end

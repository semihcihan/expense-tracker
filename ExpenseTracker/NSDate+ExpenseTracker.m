//
//  NSDate+ExpenseTracker.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NSDate+ExpenseTracker.h"
#import "NSLocale+ExpenseTracker.h"

@implementation NSDate (ExpenseTracker)

- (NSString *)localeDateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *fullDateString = [dateFormatter stringFromDate:self];
    return fullDateString;
}

- (NSInteger)weekDifferenceWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear|NSCalendarUnitYear fromDate:self];
    NSInteger week = [components weekOfYear];
    NSInteger year = [components year];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekOfYear|NSCalendarUnitYear fromDate:date];
    NSInteger dateWeek = [dateComponents weekOfYear];
    NSInteger dateYear = [dateComponents year];
    
    NSUInteger numberOfWeeksInAYear = [calendar maximumRangeOfUnit:NSCalendarUnitWeekOfYear].length;
    ;
    
    return (week + (year - dateYear) * numberOfWeeksInAYear) - dateWeek;
}

- (NSInteger)monthDifferenceWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    NSInteger dateMonth = [dateComponents month];
    NSInteger dateYear = [dateComponents year];
    
    NSUInteger numberOfMonthsInAYear = [calendar maximumRangeOfUnit:NSCalendarUnitMonth].length;
    ;
    
    return (month + (year - dateYear) * numberOfMonthsInAYear) - dateMonth;
}

- (NSDateComponents *)weekOfYearAndYearComponents {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear|NSCalendarUnitYear fromDate:self];
    
    return components;
}

@end

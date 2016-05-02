//
//  Expense.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Parse/Parse.h>

@interface Expense : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *expenseDescription;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSDate *date;

@end

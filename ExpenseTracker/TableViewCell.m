//
//  TableViewCell.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end

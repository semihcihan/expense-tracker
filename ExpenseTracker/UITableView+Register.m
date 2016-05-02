//
//  UITableView+Register.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "UITableView+Register.h"

@implementation UITableView (Register)

- (void)registerCellClassForDefaultReuseIdentifier:(Class)cellClass;
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

@end

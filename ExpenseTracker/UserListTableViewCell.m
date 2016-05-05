//
//  UserListTableViewCell.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "UserListTableViewCell.h"

@implementation UserListTableViewCell

- (IBAction)banButtonTapped:(id)sender {
    [self.delegate banButtonTapped:self];
}

+ (CGFloat)height {
    return 60.f;
}

@end

//
//  UserDetails.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "UserDetails.h"

@implementation UserDetails

@dynamic user, role, banned;

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (void)load {
    [self registerSubclass];
}

@end

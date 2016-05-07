//
//  UserDetails.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Parse/Parse.h>

typedef NS_ENUM(NSUInteger, UserRole) {
    UserRoleUndefined,
    UserRoleRegular,
    UserRoleUserManager,
    UserRoleAdmin
};

@interface UserDetails : PFObject <PFSubclassing>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFRole *role;
@property (assign, nonatomic) BOOL banned;

- (UserRole)userRole;

@end

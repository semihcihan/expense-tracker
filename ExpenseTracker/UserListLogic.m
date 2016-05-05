//
//  UserListLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "UserListLogic.h"

@implementation UserListLogic

- (void)getUsersAndUserDetailsWithSuccessBlock:(void (^)(NSArray *))successBlock
                    failureBlock:(FailureBlock)failureBlock {
    
    [NetworkManager getUsersAndUserDetailsWithSuccessBlock:^(NSArray *usersAndUserDetails)
    {
        self.users = usersAndUserDetails[0];
        self.userDetails = [UserListLogic orderUserDetails:usersAndUserDetails[1] accordingToUsers:self.users];
        
        successBlock(usersAndUserDetails);
    }
                                failureBlock:^(NSString *error)
    {
        failureBlock(error);
    }];
}

+ (void)logout {
    [NetworkManager logout];
    
    //clear user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+ (NSArray *)orderUserDetails:(NSArray *)userDetailsArray accordingToUsers:(NSArray *)usersArray {
    
    NSMutableArray *userDetailsArrayOrdered = @[].mutableCopy;
    for (PFUser *user in usersArray)
    {
        for (UserDetails *userDetails in userDetailsArray)
        {
            if ([userDetails.user.objectId isEqualToString:user.objectId])
            {
                [userDetailsArrayOrdered addObject:userDetails];
                break;
            }
        }
    }
    
    return userDetailsArrayOrdered;
}

@end

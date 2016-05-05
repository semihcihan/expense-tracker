//
//  UserListLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "UserListLogic.h"

@interface UserListLogic ()

@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSArray *userDetails;

@end

@implementation UserListLogic

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shownUsers = @[].mutableCopy;
        self.shownUserDetails = @[].mutableCopy;
    }
    return self;
}

- (void)getUsersAndUserDetailsWithSuccessBlock:(void (^)(NSArray *))successBlock
                    failureBlock:(FailureBlock)failureBlock {
    
    [NetworkManager getUsersAndUserDetailsWithSuccessBlock:^(NSArray *usersAndUserDetails)
    {
        self.users = usersAndUserDetails[0];
        self.userDetails = [UserListLogic orderUserDetails:usersAndUserDetails[1] accordingToUsers:self.users];
        
        [self.shownUsers removeAllObjects];
        [self.shownUsers addObjectsFromArray:self.users];
        
        [self.shownUserDetails removeAllObjects];
        [self.shownUserDetails addObjectsFromArray:self.userDetails];
        
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

- (void)banUser:(PFUser *)user
         banned:(BOOL)banned
    userDetails:(UserDetails *)userDetails
   successBlock:(void (^)(void))successBlock
   failureBlock:(FailureBlock)failureBlock {
    
    [NetworkManager banUser:user banned:banned userDetails:userDetails successBlock:^
    {
        successBlock();
    }
               failureBlock:^(NSString *error)
    {
        failureBlock(error);
    }];
}

- (void)filterEmailsWithKeyword:(NSString *)keyword {
    
    if (keyword.length > 0)
    {
        NSString *lowercaseKeyword = keyword.lowercaseString;
        
        NSMutableArray *filteredShownUsers = @[].mutableCopy;
        
        for (PFUser *user in self.shownUsers)
        {
            if ([user.username.lowercaseString containsString:lowercaseKeyword])
            {
                [filteredShownUsers addObject:user];
            }
        }
        
        NSMutableArray *filteredShownUserDetails = @[].mutableCopy;
        
        for (UserDetails *userDetails in self.shownUserDetails)
        {
            if ([userDetails.user.username.lowercaseString containsString:lowercaseKeyword])
            {
                [filteredShownUserDetails addObject:userDetails];
            }
        }
        
        self.shownUsers = filteredShownUsers;
        self.shownUserDetails = filteredShownUserDetails;
    }
    else
    {
        [self.shownUsers removeAllObjects];
        [self.shownUsers addObjectsFromArray:self.users];
        
        [self.shownUserDetails removeAllObjects];
        [self.shownUserDetails addObjectsFromArray:self.userDetails];
    }
    
}

@end

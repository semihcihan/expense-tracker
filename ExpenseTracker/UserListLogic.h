//
//  UserListLogic.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface UserListLogic : NSObject

@property (strong, nonatomic) NSMutableArray *shownUsers;
@property (strong, nonatomic) NSMutableArray *shownUserDetails;

- (void)getUsersAndUserDetailsWithSuccessBlock:(void (^)(NSArray *usersAndUserDetails))successBlock
                                  failureBlock:(FailureBlock)failureBlock;

+ (void)logout;

- (void)banUser:(PFUser *)user
         banned:(BOOL)banned
    userDetails:(UserDetails *)userDetails
   successBlock:(void (^)(void))successBlock
   failureBlock:(FailureBlock)failureBlock;

- (void)filterEmailsWithKeyword:(NSString *)keyword;

@end

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

@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSArray *userDetails;

- (void)getUsersAndUserDetailsWithSuccessBlock:(void (^)(NSArray *usersAndUserDetails))successBlock
                                  failureBlock:(FailureBlock)failureBlock;

+ (void)logout;

@end

//
//  RestNetworkManager.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 08/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <Parse.h>

@interface RestNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
             successBlock:(void (^)(NSString *sessionToken))success
             failureBlock:(void (^)(NSError *error))failure;

- (void)getExpensesOfUserWithObjectId:(NSString *)userObjectId                         
                         successBlock:(void (^)(NSArray *expenses))success
                         failureBlock:(void (^)(NSError *error))failure;

- (void)getCurrentUserObjectIdWithSessionToken:(NSString *)sessionToken
                                  successBlock:(void (^)(NSString *userObjectId))success
                                  failureBlock:(void (^)(NSError *error))failure;

@end

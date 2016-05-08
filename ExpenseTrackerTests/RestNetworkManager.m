//
//  RestNetworkManager.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 08/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "RestNetworkManager.h"

@implementation RestNetworkManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[RestNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.parse.com/1/"]];
        ((RestNetworkManager *)sharedInstance).responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json"]];
        [((RestNetworkManager *)sharedInstance).requestSerializer setTimeoutInterval:30];
        [((RestNetworkManager *)sharedInstance).requestSerializer setValue:@"36OeiYfmPQhkxUDFEguMG5pKVBqMibQCIpDiwrkD" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [((RestNetworkManager *)sharedInstance).requestSerializer setValue:@"r70GZMO8X3aEbr3tu3NEBof12HQB5yICSWZkrOkE" forHTTPHeaderField:@"X-Parse-REST-API-Key"];

    });
    return sharedInstance;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
             successBlock:(void (^)(NSString *sessionToken))success
             failureBlock:(void (^)(NSError *error))failure {
    
    [self GET:@"login"
   parameters:@{@"username" : username,
                @"password" : password}
     progress:^(NSProgress * _Nonnull downloadProgress) {}
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"sessionToken"])
        {
            [RestNetworkManager saveSessionToken:responseObject[@"sessionToken"]];
            [[RestNetworkManager sharedInstance].requestSerializer setValue:[RestNetworkManager getSessionToken] forHTTPHeaderField:@"X-Parse-Session-Token"];
            success([RestNetworkManager getSessionToken]);
        }
        else
        {
            failure(nil);
        }
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        failure(error);
    }];
    
}

- (void)getExpensesOfUserWithObjectId:(NSString *)userObjectId
                         successBlock:(void (^)(NSArray *))success
                         failureBlock:(void (^)(NSError *))failure {
    
    [[RestNetworkManager sharedInstance].requestSerializer setValue:[RestNetworkManager getSessionToken] forHTTPHeaderField:@"X-Parse-Session-Token"];
    
    [self GET:@"classes/Expense"
   parameters:@{@"user" : @{@"__type" : @"Pointer", @"className" : @"Expense", @"objectId" : userObjectId}}
     progress:^(NSProgress * _Nonnull downloadProgress) {}
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"results"])
         {
             success(responseObject[@"results"]);
         }
         else
         {
             failure(nil);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         failure(error);
     }];
}

- (void)getCurrentUserObjectIdWithSessionToken:(NSString *)sessionToken
                                  successBlock:(void (^)(NSString *))success
                                  failureBlock:(void (^)(NSError *))failure {
    
    [[RestNetworkManager sharedInstance].requestSerializer setValue:[RestNetworkManager getSessionToken] forHTTPHeaderField:@"X-Parse-Session-Token"];

    [self GET:@"users/me"
   parameters:nil
     progress:^(NSProgress * _Nonnull downloadProgress) {}
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"objectId"])
         {
             NSString *sessionToken = responseObject[@"objectId"];
             success(sessionToken);
         }
         else
         {
             failure(nil);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         failure(error);
     }];
}

#pragma mark - Helpers

+ (void)saveSessionToken:(NSString *)sessionToken {
    
    [[NSUserDefaults standardUserDefaults] setObject:sessionToken forKey:@"SessionToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getSessionToken {
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionToken"];
    if (sessionToken)
    {
        return sessionToken;
    }
    else
    {
        return @"";
    }
}

@end

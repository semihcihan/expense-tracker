//
//  OpeningLogic.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "OpeningLogic.h"

@implementation OpeningLogic

- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validatePassword:(NSString *)password {
    
    return password.length >= 6;
}

- (void)signUp:(NSString *)email
      password:(NSString *)password
  successBlock:(void (^)(PFUser *))successBlock
  failureBlock:(FailureBlock)failureBlock {
    
    [NetworkManager signUpWithEmail:email
                           password:password
                       successBlock:^(PFUser *user)
    {
        successBlock(user);
    }
                       failureBlock:^(NSString *error)
    {
        failureBlock(error);
    }];
    
}

- (void)login:(NSString *)email
     password:(NSString *)password
 successBlock:(void (^)(PFUser *))successBlock
 failureBlock:(FailureBlock)failureBlock {
    
    [NetworkManager loginWithEmail:email
                          password:password
                      successBlock:^(PFUser *user)
     {
         successBlock(user);
     }
                      failureBlock:^(NSString *error)
     {
         failureBlock(error);
     }];
    
}

- (BOOL)isUserRegular {
    
    return [NetworkManager currentUserRole] == UserRoleRegular;
}

+ (PFUser *)currentUser {
    return [NetworkManager currentUser];
}


@end

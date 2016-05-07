//
//  NetworkManager.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NetworkManager.h"

static NSString * const kDefaultErrorMessage = @"An error occurred.";

@implementation NetworkManager

+ (instancetype)sharedInstance
{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = @"36OeiYfmPQhkxUDFEguMG5pKVBqMibQCIpDiwrkD";
            configuration.clientKey = @"LCK73e1wbmdKXRLiOpsYwKJDpQkI0JFw2d8ggotS";
        }]];
    });
    return sharedInstance;
}

+ (PFUser *)currentUser {
    return [PFUser currentUser];
}

+ (void)logout {
    [PFUser logOutInBackground];
}

+ (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
           successBlock:(void (^)(PFUser *))successBlock
           failureBlock:(FailureBlock)failureBlock {
    
    PFUser *user = [PFUser user];
    user.password = password;
    user.username = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            UserDetails *userDetails = [[UserDetails  alloc] init];
            userDetails.user = [NetworkManager currentUser];
            userDetails.banned = NO;
            
            PFACL *acl = [PFACL ACL];
            [acl setPublicReadAccess:NO];
            [acl setPublicWriteAccess:NO];
            [acl setReadAccess:YES forUser:[NetworkManager currentUser]];
            [acl setWriteAccess:YES forUser:[NetworkManager currentUser]];
            
            PFQuery *queryRole = [PFRole query];
            [queryRole findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (!error)
                {
                    for (PFRole *role in objects) {
                        [acl setReadAccess:YES forRole:role];
                        [acl setWriteAccess:YES forRole:role];
                    }
                    userDetails.ACL = acl;
                    
                    [userDetails saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
                     {
                         if (succeeded)
                         {
                             [NetworkManager saveCurrentUserRole:UserRoleRegular];
                             successBlock([NetworkManager currentUser]);
                         }
                         else
                         {
                             [[NetworkManager currentUser] deleteInBackground];
                             failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
                         }
                     }];
                }
                else
                {
                    failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
                }
            }];
        }
        else
        {
            failureBlock([error userInfo][@"error"]);
        }
        
    }];
}

+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
          successBlock:(void (^)(PFUser *))successBlock
          failureBlock:(FailureBlock)failureBlock {
    
    [PFUser logInWithUsernameInBackground:email
                                 password:password
                                    block:^(PFUser *user, NSError *error)
    {
        if (user)
        {
            PFQuery *query = [UserDetails query];
            [query includeKey:@"role"];
            [query whereKey:@"user" equalTo:[NetworkManager currentUser]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error)
            {
                UserDetails *userDetails = (UserDetails *)object;
                if (!error && userDetails)
                {
                    if (userDetails.banned)
                    {
                        [NetworkManager logout];
                        failureBlock(NSLocalizedString(@"Sorry, you're banned.", nil));
                    }
                    else
                    {
                        [NetworkManager saveCurrentUserRole:[userDetails userRole]];
                        successBlock([NetworkManager currentUser]);
                    }
                }
                else
                {
                    [NetworkManager logout];
                    failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
                }
                
            }];
        }
        else
        {
            failureBlock([error userInfo][@"error"]);
        }
        
    }];
}

+ (void)getExpensesOfUser:(PFUser *)user
             successBlock:(void (^)(NSArray *expenses))successBlock
             failureBlock:(FailureBlock)failureBlock {
    
    PFQuery *query = [Expense query];
    [query whereKey:@"user" equalTo:user];
    [query orderByDescending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            successBlock(objects);
        }
        else
        {
            failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
        }
    }];
    
}

+ (void)saveChangesOnExpense:(Expense *)expense
                      ofUser:(PFUser *)user
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSString *))failureBlock {
    
    expense.user = user;
    PFACL *acl = [PFACL ACL];
    [acl setPublicReadAccess:NO];
    [acl setPublicWriteAccess:NO];
    [acl setReadAccess:YES forUser:user];
    [acl setWriteAccess:YES forUser:user];
    
    PFQuery *queryRole = [PFRole query];
    [queryRole whereKey:@"name" equalTo:@"admin"];
    [queryRole getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (!error)
        {
            PFRole *role = (PFRole *)object;
            [acl setReadAccess:YES forRole:role];
            [acl setWriteAccess:YES forRole:role];
            expense.ACL = acl;
            
            [expense saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
             {
                 if (succeeded)
                 {
                     successBlock();
                 }
                 else
                 {
                     failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
                 }
             }];
        }
        else
        {
            failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
        }
    }];

    

}

+ (void)deleteExpense:(Expense *)expense
         successBlock:(void (^)(void))successBlock
         failureBlock:(void (^)(NSString *))failureBlock {
    
    [expense deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (succeeded)
        {
            successBlock();
        }
        else
        {
            failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
        }
    }];
}

+ (void)getUsersAndUserDetailsWithSuccessBlock:(void (^)(NSArray *))successBlock
                                  failureBlock:(FailureBlock)failureBlock {
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            NSArray *users = objects;
            PFQuery *query = [UserDetails query];
            [query includeKey:@"user"];
            [query includeKey:@"role"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
            {
                if (!error)
                {
                    NSMutableArray *usersAndUserDetails = @[].mutableCopy;
                    usersAndUserDetails[0] = users;
                    usersAndUserDetails[1] = objects;
                    
                    successBlock(usersAndUserDetails);
                }
                else
                {
                    failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
                }
            }];
        }
        else
        {
            failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
        }
    }];
}

+ (void)banUser:(PFUser *)user
         banned:(BOOL)banned
   userDetails:(UserDetails *)userDetails
   successBlock:(void (^)(void))successBlock
   failureBlock:(FailureBlock)failureBlock {
 
    userDetails.banned = banned;
    
    [userDetails saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (succeeded)
        {
            successBlock();
        }
        else
        {
            failureBlock(NSLocalizedString(kDefaultErrorMessage, nil));
        }
    }];
    

}

+ (UserRole)currentUserRole {
    
    NSNumber *userRole = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserRole"];
    if (!userRole)
    {
        return UserRoleUndefined;
    }
    else
    {
        return [userRole integerValue];
    }
}

#pragma mark - Private

+ (void)saveCurrentUserRole:(UserRole)role {
    [[NSUserDefaults standardUserDefaults] setObject:@(role) forKey:@"UserRole"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

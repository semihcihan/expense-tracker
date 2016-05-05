//
//  NetworkManager.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NetworkManager.h"

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
    [PFUser logOut];
}

+ (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
           successBlock:(void (^)(PFUser *))successBlock
           failureBlock:(FailureBlock)failureBlock {
    
    PFUser *user = [PFUser user];
    user.password = password;
    user.username = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            successBlock([NetworkManager currentUser]);
        }
        else
        {
            failureBlock(@"An error occurred.");
        }
    }];
}

+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
          successBlock:(void (^)(PFUser *))successBlock
          failureBlock:(FailureBlock)failureBlock {
    
    
    [PFUser logInWithUsernameInBackground:email
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            successBlock([NetworkManager currentUser]);
                                        } else {
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            successBlock(objects);
        }
        else
        {
            failureBlock([error userInfo][@"error"]);
        }
    }];
    
}

+ (void)saveChangesOnExpense:(Expense *)expense
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSString *))failureBlock {
    
#warning we are setting the user of the expense, attention when saving from admin
    expense.user = [NetworkManager currentUser];
    PFACL *acl = [PFACL ACL];
    [acl setPublicReadAccess:NO];
    [acl setPublicWriteAccess:NO];
    [acl setReadAccess:YES forUser:[NetworkManager currentUser]];
    [acl setWriteAccess:YES forUser:[NetworkManager currentUser]];
    
    PFQuery *queryRole = [PFRole query];
    [queryRole whereKey:@"name" equalTo:@"admin"];
    [queryRole getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
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
                     failureBlock(@"An error occurred.");
                 }
             }];
        }
        else
        {
            failureBlock(@"An error occurred.");
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
            failureBlock([error localizedDescription]);
        }
    }];
}

@end

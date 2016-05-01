//
//  OpeningLogic.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface OpeningLogic : NSObject


- (BOOL)validateEmail:(NSString *)email;
- (BOOL)validatePassword:(NSString *)password;
- (void)signUp:(NSString *)email
      password:(NSString *)password
  successBlock:(void (^)(PFUser *))successBlock
  failureBlock:(FailureBlock)failureBlock;
- (void)login:(NSString *)email
     password:(NSString *)password
 successBlock:(void (^)(PFUser *))successBlock
 failureBlock:(FailureBlock)failureBlock;


@end

//
//  CBAlertManager.m
//  Haber3
//
//  Created by Necati Aydın on 26/01/15.
//  Copyright (c) 2014 Mobilike. All rights reserved.
//

#import "AlertManager.h"

@interface AlertManager()<UIAlertViewDelegate>

@property (nonatomic, copy) void (^completionHandler)(NSInteger buttonClicked);
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation AlertManager

+ (instancetype)sharedInstance
{
    static AlertManager *manager = nil;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        manager = [AlertManager new];
    });
    
    return manager;
}

+ (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitles:(NSArray *)otherButtonTitles
             viewController:(UIViewController *)viewController
          completionHandler:(void (^)(NSInteger buttonClicked))completionHandler
{
    [AlertManager sharedInstance].alertController = [UIAlertController alertControllerWithTitle:title.copy
                                                                                          message:message.copy
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    
    if(cancelButtonTitle)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           if(completionHandler)
                                                           {
                                                               completionHandler(0);
                                                           }
                                                       }];
        
        [[AlertManager sharedInstance].alertController addAction:action];
    }
    
    for(NSInteger i = 0; i < otherButtonTitles.count; i++)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherButtonTitles[i]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           if(completionHandler)
                                                           {
                                                               completionHandler(i+1);
                                                           }
                                                       }];
        
        [[AlertManager sharedInstance].alertController addAction:action];
    }
    
    [viewController presentViewController:[AlertManager sharedInstance].alertController animated:YES completion:nil];
    
}

@end

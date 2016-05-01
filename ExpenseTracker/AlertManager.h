//
//  AlertManager.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 A manager for the UIAlertController.
 */
@interface AlertManager : NSObject

/**
 Shows an alert with the givene inputs. For iOS 7, internally, it uses alert view. For iOS 8 and higher it uses the new aler controller.
 @param title Title of the alert.
 @param message Message of the alert.
 @param cancelButtonTitle Title of the default destructive alert button.
 @param otherButtonTitle Titles of the non-destructive alert buttons.
 @param viewController The view contoller in which the alert is going to be shown.
 @param completionHandler The index of the clicked button is returned in the block parameters. 0 is used for the destructive button.
 */
+ (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitles:(NSArray *)otherButtonTitles
             viewController:(UIViewController *)viewController
          completionHandler:(void (^)(NSInteger buttonClicked))completionHandler;
@end

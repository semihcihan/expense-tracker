//
//  NavigationBarStyler.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationBarStyler : NSObject

+ (void)styleNavigationBar;
+ (void)styleLeftNavigationItem:(UINavigationItem *)navigationItem
                          image:(UIImage *)image
                         target:(id)target
                         action:(SEL)action;

- (void)styleRightNavigationItem:(UINavigationItem *)navigationItem
                           image:(UIImage *)image
                          target:(id)target
                          action:(SEL)action;

- (void)styleRightNavigationItem:(UINavigationItem *)navigationItem
               firstButtonAction:(SEL)settingsAction
                firstButtonImage:(UIImage *)firstButtonImage
              secondButtonAction:(SEL)infoAction
               secondButtonImage:(UIImage *)secondButtonImage
                          target:(id)target;

@end

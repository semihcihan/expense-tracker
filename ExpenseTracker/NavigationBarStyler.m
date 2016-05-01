//
//  NavigationBarStyler.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NavigationBarStyler.h"

@implementation NavigationBarStyler

+ (void)styleNavigationBar {
    
}

+ (void)styleLeftNavigationItem:(UINavigationItem *)navigationItem
                          image:(UIImage *)image
                         target:(id)target
                         action:(SEL)action {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    navigationItem.leftBarButtonItem = item;
}

+ (void)styleRightNavigationItem:(UINavigationItem *)navigationItem
                           image:(UIImage *)image
                          target:(id)target
                          action:(SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    navigationItem.rightBarButtonItem = item;
}

+ (void)styleRightNavigationItem:(UINavigationItem *)navigationItem
               firstButtonAction:(SEL)settingsAction
                firstButtonImage:(UIImage *)firstButtonImage
              secondButtonAction:(SEL)infoAction
               secondButtonImage:(UIImage *)secondButtonImage
                          target:(id)target {
    
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc] initWithImage:firstButtonImage style:UIBarButtonItemStylePlain target:target action:settingsAction];
    [firstItem setImageInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, -10.f)];
    
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc] initWithImage:secondButtonImage style:UIBarButtonItemStylePlain target:target action:infoAction];
    [secondItem setImageInsets:UIEdgeInsetsMake(0.f, -10.f, 0.f, 0.f)];
    
    navigationItem.rightBarButtonItems = @[secondItem, firstItem];
}

@end

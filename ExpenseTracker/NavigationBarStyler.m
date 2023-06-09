//
//  NavigationBarStyler.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "NavigationBarStyler.h"
#import "UIColor+ExpenseTracker.h"

@implementation NavigationBarStyler

+ (void)styleNavigationBar {
    [[UINavigationBar appearance] setTintColor:[UIColor mainBlueColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:20.f],
                                                           NSForegroundColorAttributeName:[UIColor mainBlueColor]
                                                           }];

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
               firstButtonAction:(SEL)firstButtonAction
                firstButtonImage:(UIImage *)firstButtonImage
              secondButtonAction:(SEL)secondButtonAction
               secondButtonImage:(UIImage *)secondButtonImage
                          target:(id)target {
    
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc] initWithImage:firstButtonImage style:UIBarButtonItemStylePlain target:target action:firstButtonAction];
    [firstItem setImageInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, -10.f)];
    
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc] initWithImage:secondButtonImage style:UIBarButtonItemStylePlain target:target action:secondButtonAction];
    [secondItem setImageInsets:UIEdgeInsetsMake(0.f, -10.f, 0.f, 0.f)];
    
    navigationItem.rightBarButtonItems = @[secondItem, firstItem];
}

@end

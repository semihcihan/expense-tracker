//
//  AppDelegate.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkManager.h"
#import "NavigationBarStyler.h"
#import <UIView+Toast.h>
#import "ViewController.h"
#import "ExpenseViewController.h"
#import "UserListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [AppDelegate customizeClasses];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    PFUser *currentUser = [NetworkManager currentUser];
    
    if(!currentUser)
    {
        [ViewController goToOpeningViewController];
    }
    else if (currentUser && [NetworkManager currentUserRole] == UserRoleRegular)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ExpenseViewController *viewController = (ExpenseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ExpenseViewController"];
        viewController.logic = [[ExpenseLogic alloc] init];
        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    }
    else //admin or user-admin
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserListViewController *viewController = (UserListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
        viewController.logic = [[UserListLogic alloc] init];
        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helpers

+ (void)customizeClasses {
    [NetworkManager sharedInstance];
    [NavigationBarStyler styleNavigationBar];
    [CSToastManager setQueueEnabled:NO];
}

@end

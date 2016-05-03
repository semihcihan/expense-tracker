//
//  ViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBar.translucent = NO;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)goToOpeningViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RegularUser" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RegularUserInitialNavigationController"];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController = viewController;
}

@end

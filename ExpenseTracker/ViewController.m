//
//  ViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ViewController.h"
#import <UIView+Toast.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [CSToastManager setQueueEnabled:NO];
    });
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

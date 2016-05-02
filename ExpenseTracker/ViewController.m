//
//  ViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBar.translucent = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    });
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

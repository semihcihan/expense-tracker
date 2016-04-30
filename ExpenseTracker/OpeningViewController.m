//
//  OpeningViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "OpeningViewController.h"

@interface OpeningViewController () <UITextFieldDelegate>

- (IBAction)signInButtonTapped:(id)sender;
- (IBAction)signUpButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation OpeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)signInButtonTapped:(id)sender {
    
}

- (IBAction)signUpButtonTapped:(id)sender {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; //dismiss keyboard
}

@end

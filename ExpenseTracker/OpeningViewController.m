//
//  OpeningViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 30/04/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "OpeningViewController.h"
#import <UIView+Toast.h>
#import "UIView+Loading.h"
#import "ExpenseViewController.h"

@interface OpeningViewController () <UITextFieldDelegate>

- (IBAction)signInButtonTapped:(id)sender;
- (IBAction)signUpButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation OpeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logic = [[OpeningLogic alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.emailTextField.text = @"se@i.co";
    self.passwordTextField.text = @"22323333";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
    ((ExpenseViewController *)segue.destinationViewController).logic = [[ExpenseLogic alloc] init];
}

#pragma mark - Actions

- (IBAction)signInButtonTapped:(id)sender {
    
    if ([self validate])
    {
        [self.view showLoadingView];
        
        [self.logic login:self.emailTextField.text
                 password:self.passwordTextField.text
             successBlock:^(PFUser *user)
         {
             [self.view dismissLoadingView];
             [self performSegueWithIdentifier:@"FeedViewController" sender:self];
         }
             failureBlock:^(NSString *error)
         {
             [self.view dismissLoadingView];
             [self.view makeToast:error duration:2 position:CSToastPositionCenter];
         }];
    }
    
}

- (IBAction)signUpButtonTapped:(id)sender {
    
    if ([self validate])
    {
        [self.logic signUp:self.emailTextField.text
                  password:self.passwordTextField.text
              successBlock:^(PFUser *user)
        {
            [self.view dismissLoadingView];
            [self performSegueWithIdentifier:@"FeedViewController" sender:self];
        }
              failureBlock:^(NSString *error)
        {
            [self.view dismissLoadingView];
            [self.view makeToast:error duration:2 position:CSToastPositionCenter];
        }];
    }
    
}

#pragma mark - Helpers

- (BOOL)validate {
    
    if (self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0)
    {
        if (![self.logic validateEmail:self.emailTextField.text])
        {
            [self.view makeToast:@"Invalid email" duration:2 position:CSToastPositionCenter];
            
        }
        else if (![self.logic validatePassword:self.passwordTextField.text])
        {
            [self.view makeToast:@"Invalid password" duration:2 position:CSToastPositionCenter];
        }
        else
        {
            return YES;
        }
    }
    else
    {
        [self.view makeToast:@"Please fill in all the fields." duration:2 position:CSToastPositionCenter];
    }
    
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
    }
    
    return YES;
}

@end

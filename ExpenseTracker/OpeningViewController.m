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
#import "ExpenseListViewController.h"
#import "UserListViewController.h"

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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:NSStringFromClass([ExpenseListViewController class])])
    {
        ExpenseListLogic *logic = [[ExpenseListLogic alloc] init];
        logic.user = [OpeningLogic currentUser];
        ((ExpenseListViewController *)segue.destinationViewController).logic = logic;
    }
    else
    {
        ((UserListViewController *)segue.destinationViewController).logic = [[UserListLogic alloc] init];
    }
}

#pragma mark - Actions

- (IBAction)signInButtonTapped:(id)sender {
    
    if ([self validate])
    {
        [self.view showLoadingView];
        
        [OpeningLogic login:self.emailTextField.text
                   password:self.passwordTextField.text
               successBlock:^(PFUser *user)
         {
             [self.view dismissLoadingView];
             if ([OpeningLogic isUserRegular])
             {
                [self performSegueWithIdentifier:NSStringFromClass([ExpenseListViewController class]) sender:self];
             }
             else
             {
                 [self performSegueWithIdentifier:NSStringFromClass([UserListViewController class]) sender:self];
             }
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
        [self.view showLoadingView];
        
        [OpeningLogic signUp:self.emailTextField.text
                    password:self.passwordTextField.text
                successBlock:^(PFUser *user)
        {
            [self.view dismissLoadingView];
            if ([OpeningLogic isUserRegular])
            {
                [self performSegueWithIdentifier:NSStringFromClass([ExpenseListViewController class]) sender:self];
            }
            else
            {
                [self performSegueWithIdentifier:NSStringFromClass([UserListViewController class]) sender:self];
            }
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
    
    [self.view endEditing:YES];
    
    if (self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0)
    {
        if (![OpeningLogic validateEmail:self.emailTextField.text])
        {
            [self.view makeToast:NSLocalizedString(@"Invalid email", nil) duration:2 position:CSToastPositionCenter];
            
        }
        else if (![OpeningLogic validatePassword:self.passwordTextField.text])
        {
            [self.view makeToast:NSLocalizedString(@"The password must be at least 6 characters long.", nil) duration:2 position:CSToastPositionCenter];
        }
        else
        {
            return YES;
        }
    }
    else
    {
        [self.view makeToast:NSLocalizedString(@"Please fill in all the fields.", nil) duration:2 position:CSToastPositionCenter];
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

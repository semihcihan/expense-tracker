//
//  ExpenseDetailViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 04/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseDetailViewController.h"
#import "NavigationBarStyler.h"
#import "NSNumber+ExpenseTracker.h"
#import "NSDate+ExpenseTracker.h"
#import "NSString+ExpenseTracker.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import "UIColor+ExpenseTracker.h"
#import "UIView+Loading.h"
#import <UIView+Toast.h>
#import "AlertManager.h"

@interface ExpenseDetailViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountDecimalTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountSeparatorTextField;
- (IBAction)dateButtonTapped:(id)sender;

@end

@implementation ExpenseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Expense Detail", nil);
    
    [NavigationBarStyler styleLeftNavigationItem:self.navigationItem
                                           image:[UIImage imageNamed:@"close"]
                                          target:self
                                          action:@selector(closeButtonTapped)];


    if (self.logic.expense)
    {
        [NavigationBarStyler styleRightNavigationItem:self.navigationItem
                                    firstButtonAction:@selector(deleteButtonTapped)
                                     firstButtonImage:[UIImage imageNamed:@"trash"]
                                   secondButtonAction:@selector(saveButtonTapped)
                                    secondButtonImage:[UIImage imageNamed:@"ok"]
                                               target:self];
    }
    else
    {
        [NavigationBarStyler styleRightNavigationItem:self.navigationItem
                                                image:[UIImage imageNamed:@"ok"]
                                               target:self
                                               action:@selector(saveButtonTapped)];
    }
    
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    [self fillExpenseData];
}

- (void)fillExpenseData {
    
    if (self.logic.expense) //update or delete an old expense
    {
        [self.dateButton setTitle:[self.logic.expense.date localeDateString] forState:UIControlStateNormal];
        self.descriptionTextField.text = self.logic.expense.expenseDescription;
        self.commentTextField.text = self.logic.expense.comment;
        NSArray *amountSeparated = [self.logic.expense.amount splitNumber];
        self.amountTextField.text = amountSeparated[0];
        self.amountDecimalTextField.text = amountSeparated[1];
        self.amountSeparatorTextField.text = [NSString percentSymbol];
    }
    else //new expense
    {
        self.logic.expense = [[Expense alloc] init];
        self.logic.expense.date = [NSDate date];
    }
}

#pragma mark - Actions

- (void)dismissKeyboard {
    
    [self.scrollView endEditing:YES];
}

- (void)closeButtonTapped {
    
    [self dismissKeyboard];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteButtonTapped {
    
    [self dismissKeyboard];

    [AlertManager showAlertWithTitle:nil
                             message:NSLocalizedString(@"Are you sure you want to delete this expense?", nil)
                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                   otherButtonTitles:@[NSLocalizedString(@"Delete", nil)]
                      viewController:self
                   completionHandler:^(NSInteger buttonClicked)
    {
        if (buttonClicked == 1)
        {
            [self.view showLoadingView];
            [self.logic deleteExpenseWithSuccessBlock:^
            {
                [self.view dismissLoadingView];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
                                         failureBlock:^(NSString *error)
            {
                [self.view dismissLoadingView];
                [self.view makeToast:error duration:2 position:CSToastPositionCenter];
            }];
        }
    }];
}

- (void)saveButtonTapped {
        
    [self dismissKeyboard];
    
    //check mandatory fields
    if (!(self.amountDecimalTextField.text.length > 0 || self.amountTextField.text.length > 0))
    {
        [AlertManager showAlertWithTitle:nil
                                 message:NSLocalizedString(@"Please set the amount of expense", nil)
                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                       otherButtonTitles:nil
                          viewController:self
                       completionHandler:nil];
        return;
    }
    else if ([self.dateButton.titleLabel.text isEqualToString:NSLocalizedString(@"Select Date", nil)])
    {
        [AlertManager showAlertWithTitle:nil
                                 message:NSLocalizedString(@"Please set the date of expense", nil)
                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                       otherButtonTitles:nil
                          viewController:self
                       completionHandler:nil];
        
        return;
    }
    
    //update object
    self.logic.expense.expenseDescription = self.descriptionTextField.text;
    self.logic.expense.comment = self.commentTextField.text;
    self.logic.expense.amount = [ExpenseDetailLogic amountNumberWithIntegerPartString:self.amountTextField.text decimalPartString:self.amountDecimalTextField.text];
    
    [self.view showLoadingView];
    [self.logic saveChangesOnExpenseWithSuccessBlock:^
    {
        [self.view dismissLoadingView];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
                                        failureBlock:^(NSString *error)
    {
        [self.view dismissLoadingView];
        [self.view makeToast:error duration:2 position:CSToastPositionCenter];
    }];
}

- (void)dateButtonTapped:(id)sender {
    
    [self dismissKeyboard];

    ActionSheetDatePicker *picker = [ActionSheetDatePicker showPickerWithTitle:nil
                                                                datePickerMode:UIDatePickerModeDateAndTime
                                                                  selectedDate:self.logic.expense.date
                                                                   minimumDate:nil
                                                                   maximumDate:[NSDate date]
                                                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin)
    {
        self.logic.expense.date = selectedDate;
        [self.dateButton setTitle:[self.logic.expense.date localeDateString] forState:UIControlStateNormal];
    }
                                                                   cancelBlock:^(ActionSheetDatePicker *picker)
    {
        
    }
                                        origin:self.view];
    
    picker.toolbar.tintColor = [UIColor mainBlueColor];
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    // Prevent non numeric character input
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            return NO;
        }
    }
    
    if (textField == self.amountDecimalTextField)
    {
        // verify max length has not been exceeded
        NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (updatedText.length > 2) // 4 was chosen for SSN verification
        {    
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self dismissKeyboard];
    return YES;
}

@end

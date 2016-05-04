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
    
    self.navigationItem.title = @"Expense Detail";
    
    [NavigationBarStyler styleRightNavigationItem:self.navigationItem
                                firstButtonAction:@selector(deleteButtonTapped)
                                 firstButtonImage:[UIImage imageNamed:@"trash"]
                               secondButtonAction:@selector(saveButtonTapped)
                                secondButtonImage:[UIImage imageNamed:@"ok"] target:self];

    [NavigationBarStyler styleLeftNavigationItem:self.navigationItem image:[UIImage imageNamed:@"close"] target:self action:@selector(closeButtonTapped)];
    
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    [self fillExpenseData];
}

- (void)fillExpenseData {
    
    if (self.logic.expense)
    {
        [self.dateButton setTitle:[self.logic.expense.date localeDateString] forState:UIControlStateNormal];
        self.descriptionTextField.text = self.logic.expense.expenseDescription;
        self.commentTextField.text = self.logic.expense.comment;
        NSArray *amountSeparated = [self.logic.expense.amount splitNumber];
        self.amountTextField.text = amountSeparated[0];
        self.amountDecimalTextField.text = amountSeparated[1];
        self.amountSeparatorTextField.text = [NSString percentSymbol];
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
    
#warning show alert ok tapped delete item and tell it to expenselogic so it can remove it too
#warning New expense
}

- (void)saveButtonTapped {
    
    [self dismissKeyboard];
    
    //update object
    self.logic.expense.expenseDescription = self.descriptionTextField.text;
    self.logic.expense.comment = self.commentTextField.text;
#warning amount update
    
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
    
    ActionSheetDatePicker *picker = [ActionSheetDatePicker showPickerWithTitle:nil
                                                                datePickerMode:UIDatePickerModeDate
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self dismissKeyboard];
    return YES;
}

@end

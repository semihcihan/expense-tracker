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

@interface ExpenseDetailViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountDecimalTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountSeparatorTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)dateButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *datePickerTopLayoutConstraint;

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
    
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissControls)]];
    
    [self.datePicker setMaximumDate:[NSDate date]];
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

- (void)closeButtonTapped {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissControls {
    
    [self.scrollView endEditing:YES];
    [self dismissDatePicker];
}

- (void)dismissDatePicker {
    
    self.datePickerTopLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.4 animations:^{[self.view layoutIfNeeded];}];
}

- (void)deleteButtonTapped {
    
}

- (void)saveButtonTapped {
    
}

- (void)dateButtonTapped:(id)sender {
    
    if (self.datePickerTopLayoutConstraint.constant == 0) //close it
    {
        self.datePickerTopLayoutConstraint.constant = CGRectGetHeight(self.datePicker.frame);
    }
    else //open it
    {
        self.datePickerTopLayoutConstraint.constant = 0;
    }
    [UIView animateWithDuration:0.4 animations:^{[self.view layoutIfNeeded];}];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self dismissControls];
    return YES;
}

@end

//
//  ExpenseViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseViewController.h"
#import "UIView+Loading.h"
#import "UITableView+Register.h"
#import "ExpenseTableViewCell.h"
#import "Expense.h"
#import "NSString+ExpenseTracker.h"
#import "NSDate+ExpenseTracker.h"
#import "NSNumber+ExpenseTracker.h"
#import "NavigationBarStyler.h"
#include <math.h>

@interface ExpenseViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ErrorActionProtocol>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *amountFilterLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateFilterLabel;
@property (strong, nonatomic) IBOutlet UISlider *amountSlider;
@property (strong, nonatomic) IBOutlet UISlider *dateSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterViewVerticalSpaceToTopLayoutGuideConstraint;
@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;
@property (strong, nonatomic) IBOutlet UILabel *headerTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *headerAmountLabel;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@end

@interface ExpenseTableViewCell (Data)

- (void)fillWithExpenseData:(Expense *)expense;

@end


@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"Expenses";
    [NavigationBarStyler styleLeftNavigationItem:self.navigationItem image:[UIImage imageNamed:@"filtering"] target:self action:@selector(filterButtonTapped)];
    [NavigationBarStyler styleRightNavigationItem:self.navigationItem firstButtonAction:@selector(newExpenseButtonTapped) firstButtonImage:[UIImage imageNamed:@"new_expense"] secondButtonAction:@selector(moreButtonTapped) secondButtonImage:[UIImage imageNamed:@"more"] target:self];
    
    self.tableView.tableHeaderView = nil;
    
    [self.amountSlider addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.dateSlider addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sortSegmentedControl addTarget:self action:@selector(sortMethodChanged) forControlEvents:UIControlEventValueChanged];
    
    [self getFilterValues];
    
    [self.tableView registerCellClassForDefaultReuseIdentifier:[ExpenseTableViewCell class]];
    
    self.logic = [[ExpenseLogic alloc] init];
    [self.view showLoadingView];
    [self getData];
}

- (void)getData {
    
    [self.logic getExpensesWithSuccessBlock:^(NSArray *expenses)
     {
         [self.view dismissLoadingView];
         [self filterValueChanged:NO];
     }
                               failureBlock:^(NSString *error)
     {
         [self.view showErrorMessage:error actionMessage:@"Tap to retry" actionTarget:self];
     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; //dismiss keyboard
}

- (void)getFilterValues {
    
    self.amountSlider.value = [ExpenseLogic getAmountSliderValue];
    self.dateSlider.value = [ExpenseLogic getDateSliderValue];
    self.sortSegmentedControl.selectedSegmentIndex = [ExpenseLogic getSortSegmentValue];
}

- (void)updateSliderLabelTexts {
    
    self.amountFilterLabel.text = [ExpenseViewController amountSliderStringValue:self.amountSlider.value];
    self.dateFilterLabel.text = [ExpenseViewController dateSliderStringValue:self.dateSlider.value];
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logic.shownExpenses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpenseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ExpenseTableViewCell reuseIdentifier]];
    
    [cell fillWithExpenseData:self.logic.shownExpenses[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)filterButtonTapped {
    
    static const CGFloat kHiddenFilterViewVerticalSpace = -180.f;

    if (self.filterViewVerticalSpaceToTopLayoutGuideConstraint.constant == 0) //close it
    {
        self.filterViewVerticalSpaceToTopLayoutGuideConstraint.constant = kHiddenFilterViewVerticalSpace;
    }
    else //open it
    {
        self.filterViewVerticalSpaceToTopLayoutGuideConstraint.constant = 0;
    }
    [UIView animateWithDuration:0.4 animations:^{[self.view layoutIfNeeded];}];
    
    [self.view endEditing:YES];
}

- (void)newExpenseButtonTapped {
    
}

- (void)moreButtonTapped {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionPrint = [UIAlertAction actionWithTitle:@"Print"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    
    UIAlertAction *actionChangeCurrency = [UIAlertAction actionWithTitle:@"Change currency"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
    
    UIAlertAction *actionLogout = [UIAlertAction actionWithTitle:@"Log out"
                                                                   style:UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [ExpenseLogic logout];
                                                                     [ViewController goToOpeningViewController];
                                                                 }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Close"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    [alertController addAction:actionPrint];
    [alertController addAction:actionChangeCurrency];
    [alertController addAction:actionLogout];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)filterValueChanged:(BOOL)fromSearch {
    
    self.dateSlider.value = roundf(self.dateSlider.value);
    self.amountSlider.value = roundf(self.amountSlider.value);
    
    [self updateSliderLabelTexts];
    
    [self.logic saveFilterAmountSliderValue:self.amountSlider.value
                            dateSliderValue:self.dateSlider.value
                           sortSegmentValue:self.sortSegmentedControl.selectedSegmentIndex];
    
    [self.logic filterExpenseWithKeyword:self.searchBar.text
                      amountsGreaterThan:[ExpenseViewController amountSliderValue:self.amountSlider.value]
                           inRecentWeeks:[ExpenseViewController dateSliderValue:self.dateSlider.value]
                           sortingMethod:[ExpenseViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex]];
    
    if (self.logic.shownExpenses.count == 0)
    {
        self.noDataLabel.hidden = NO;
        self.tableView.tableHeaderView = nil;
    }
    else
    {
        self.noDataLabel.hidden = YES;
        self.headerAmountLabel.text = [[self.logic totalExpense] currencyStringRepresentation];
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
    
    [self.tableView reloadData];
    
    if (!fromSearch)
    {
        [self.view endEditing:YES];
    }
}

- (void)sortMethodChanged {
    
    [self.logic saveFilterAmountSliderValue:self.amountSlider.value
                            dateSliderValue:self.dateSlider.value
                           sortSegmentValue:self.sortSegmentedControl.selectedSegmentIndex];
    
    [self.logic sortExpenses:[ExpenseViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex]];
    
    [self.tableView reloadData];
    
    [self.view endEditing:YES];
}

- (void)errorViewTapped:(UIGestureRecognizer *)recognizer {
    
    [self.view dismissErrorView];
    [self.view showLoadingView];
    [self getData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self filterValueChanged:YES];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES]; //dismiss keyboard
}

#pragma mark - UIActionSheetDelegate


#pragma mark - Filter Value Helpers

+ (NSNumber *)amountSliderValue:(NSInteger)sliderValue {
    
    if (sliderValue == 0) {
        return @0;
    }
    
    NSInteger quotient = (sliderValue - 1) / 3;
    NSInteger rest = (sliderValue - 1) % 3;
    
    switch (rest) {
        case 0:
            return @(10 * (NSInteger)pow(10, quotient));
            break;
        case 1:
            return @(25 * (NSInteger)pow(10, quotient));
            break;
        case 2:
            return @(50 * (NSInteger)pow(10, quotient));
            break;
        default:
            return @0;
            break;
    }
}

+ (NSString *)amountSliderStringValue:(NSInteger)sliderValue {
    
    if (sliderValue > 0)
    {
        return [NSString stringWithFormat:@"Greater than %@", [[ExpenseViewController amountSliderValue:sliderValue] currencyStringRepresentationWithoutDecimals]];
    }
    else
    {
        return @"All expenses";
    }
}

+ (NSInteger)dateSliderValue:(NSInteger)sliderValue {
    switch (sliderValue) {
        case 1:
            return 1; //1 week
            break;
        case 2:
            return 2; //2 weeks
            break;
        case 3:
            return 3; //3 weeks
            break;
        case 4:
            return 4; //1 month
            break;
        case 5:
            return 8; //2 months
            break;
        case 6:
            return 12; //3 months
            break;
        case 7:
            return 24; //6 months
            break;
        case 8:
            return 52; //12 months
            break;
        default:
            return -1; //all
            break;
    }
}

+ (NSString *)dateSliderStringValue:(NSInteger)sliderValue {
    switch (sliderValue) {
        case 1:
            return @"This week"; //1 week
            break;
        case 2:
            return @"2 weeks"; //2 weeks
            break;
        case 3:
            return @"3 weeks"; //3 weeks
            break;
        case 4:
            return @"This month"; //1 month
            break;
        case 5:
            return @"2 months"; //2 months
            break;
        case 6:
            return @"3 months"; //3 months
            break;
        case 7:
            return @"6 months"; //6 months
            break;
        case 8:
            return @"12 months"; //12 months
            break;
        default:
            return @"All dates"; //all
            break;
    }
}

+ (SortingMethod)dateSegmentedControlValue:(NSInteger)selectedIndex {
    return selectedIndex;
}

@end


#pragma mark - ExpenseTableViewCell (Data)


@implementation ExpenseTableViewCell (Data)

- (void)fillWithExpenseData:(Expense *)expense {
    
    self.expenseLabel.text = [expense.amount currencyStringRepresentation];
    self.descriptionLabel.text = expense.expenseDescription;
    self.commentLabel.text = expense.comment;
    self.dateLabel.text = [expense.date localeDateString];
}

@end

//
//  ExpenseViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseListViewController.h"
#import "UIView+Loading.h"
#import "UITableView+Register.h"
#import "ExpenseListTableViewCell.h"
#import "Expense.h"
#import "NSString+ExpenseTracker.h"
#import "NSDate+ExpenseTracker.h"
#import "NSNumber+ExpenseTracker.h"
#import "NavigationBarStyler.h"
#include <math.h>
#import "UIView+NibLoading.h"
#import "ExpenseListTableViewSectionHeaderView.h"
#import "ExpenseDetailViewController.h"

@interface ExpenseListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ErrorActionProtocol>

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

@implementation ExpenseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = NSLocalizedString(@"Expenses", nil);
    
    if ([ExpenseListLogic currentUserRole] == UserRoleAdmin)
    {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        
        [NavigationBarStyler styleRightNavigationItem:self.navigationItem
                                    firstButtonAction:@selector(filterButtonTapped)
                                     firstButtonImage:[UIImage imageNamed:@"filtering"]
                                   secondButtonAction:@selector(newExpenseButtonTapped)
                                    secondButtonImage:[UIImage imageNamed:@"new_expense"] target:self];
    }
    else
    {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        
        [NavigationBarStyler styleLeftNavigationItem:self.navigationItem
                                               image:[UIImage imageNamed:@"filtering"]
                                              target:self
                                              action:@selector(filterButtonTapped)];
        
        [NavigationBarStyler styleRightNavigationItem:self.navigationItem
                                    firstButtonAction:@selector(newExpenseButtonTapped)
                                     firstButtonImage:[UIImage imageNamed:@"new_expense"]
                                   secondButtonAction:@selector(moreButtonTapped)
                                    secondButtonImage:[UIImage imageNamed:@"more"] target:self];

    }
    
    self.tableView.tableHeaderView = nil;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.amountSlider addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.dateSlider addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sortSegmentedControl addTarget:self action:@selector(sortMethodChanged) forControlEvents:UIControlEventValueChanged];
    
    [self loadFilterValues];
    
    [self.tableView registerCellClassForDefaultReuseIdentifier:[ExpenseListTableViewCell class]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //so we can filter for the changed expenses made on expense details
    if (self.logic.shownExpenses.count > 0)
    {
        [self filterValueChanged:NO];
    }
    
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)getData {

    [self.view showLoadingView];

    [self.logic getExpensesWithSuccessBlock:^(NSArray *expenses)
     {
         [self.view dismissLoadingView];
         [self filterValueChanged:NO];
     }
                               failureBlock:^(NSString *error)
     {
         [self.view showErrorMessage:error actionMessage:NSLocalizedString(@"Tap to retry", nil) actionTarget:self];
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ExpenseDetailLogic *logic = [[ExpenseDetailLogic alloc] init];
    logic.user = self.logic.user;
    if (sender && [sender isKindOfClass:[Expense class]]) //update or delete expense
    {
        logic.expense = sender;
    }
    
    ((ExpenseDetailViewController *)((UINavigationController *)segue.destinationViewController).topViewController).logic = logic;
}


#pragma mark - TableView Data Source Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return ([ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex] == SortingMethodDate
            && self.amountSlider.value == 0
            && self.dateSlider.value == 0) ? [ExpenseListTableViewSectionHeaderView height] : 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex] == SortingMethodDate
        && self.amountSlider.value == 0
        && self.dateSlider.value == 0)
    {
        ExpenseListTableViewSectionHeaderView *headerView = [ExpenseListTableViewSectionHeaderView loadFromNIB];
        NSNumber *weeklyTotal = [self.logic totalAmountOfWeek:section];
        headerView.totalAmountLabel.text = [self.logic currencyStringRepresentationOfAmount:weeklyTotal];
        headerView.averageAmountLabel.text = [self.logic currencyStringRepresentationOfAmount:@(weeklyTotal.floatValue / 7)];
        return headerView;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return ([ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex] == SortingMethodDate
            && self.amountSlider.value == 0
            && self.dateSlider.value == 0) ? self.logic.shownExpensesPerWeek.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ([ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex] == SortingMethodDate
            && self.amountSlider.value == 0
            && self.dateSlider.value == 0) ? ((NSArray *)self.logic.shownExpensesPerWeek[section]).count : self.logic.shownExpenses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [ExpenseListTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ExpenseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ExpenseListTableViewCell reuseIdentifier]];
    
    if ([ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex] == SortingMethodDate
        && self.amountSlider.value == 0
        && self.dateSlider.value == 0)
    {
        [self fillCell:cell expenseData:self.logic.shownExpensesPerWeek[indexPath.section][indexPath.row]];
    }
    else
    {
        [self fillCell:cell expenseData:self.logic.shownExpenses[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Expense *expense;
    
    if ([ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex] == SortingMethodDate
        && self.amountSlider.value == 0
        && self.dateSlider.value == 0)
    {
        expense = [self.logic.shownExpensesPerWeek[indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        expense = self.logic.shownExpenses[indexPath.row];
    }
    
    [self performSegueWithIdentifier:NSStringFromClass([ExpenseDetailViewController class]) sender:expense];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Actions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [refreshControl endRefreshing];
    
    [self getData];
}

- (void)filterButtonTapped {
    
    if (self.filterViewVerticalSpaceToTopLayoutGuideConstraint.constant == 0) //close it
    {
        self.filterViewVerticalSpaceToTopLayoutGuideConstraint.constant = -CGRectGetHeight(self.filterView.frame);
    }
    else //open it
    {
        self.filterViewVerticalSpaceToTopLayoutGuideConstraint.constant = 0;
    }
    [UIView animateWithDuration:0.4 animations:^{[self.view layoutIfNeeded];}];
    
    [self.view endEditing:YES];
}

- (void)newExpenseButtonTapped {
    
    [self performSegueWithIdentifier:NSStringFromClass([ExpenseDetailViewController class]) sender:nil];
}

- (void)moreButtonTapped {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionChangeCurrency = [UIAlertAction actionWithTitle:NSLocalizedString(@"Change Currency", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action)
    {
        [self presentChangeCurrencyAlertController];
    }];
    
    UIAlertAction *actionLogout = [UIAlertAction actionWithTitle:NSLocalizedString(@"Log Out", nil)
                                                                   style:UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [ExpenseListLogic logout];
                                                                     [ViewController goToOpeningViewController];
                                                                 }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil)
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    
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
                      amountsGreaterThan:[ExpenseListViewController amountSliderValue:self.amountSlider.value]
                           inRecentWeeks:[ExpenseListViewController dateSliderValue:self.dateSlider.value]
                           sortingMethod:[ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex]];
    
    if (self.logic.shownExpenses.count == 0)
    {
        self.noDataLabel.hidden = NO;
        self.tableView.tableHeaderView = nil;
    }
    else
    {
        self.noDataLabel.hidden = YES;
        self.headerAmountLabel.text = [self.logic currencyStringRepresentationOfAmount:[self.logic totalExpense]];
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
    
    [self.logic sortExpenses:[ExpenseListViewController dateSegmentedControlValue:self.sortSegmentedControl.selectedSegmentIndex]];
    
    [self.tableView reloadData];
    
    [self.view endEditing:YES];
}

- (void)errorViewTapped:(UIGestureRecognizer *)recognizer {
    
    [self.view dismissErrorView];
    [self getData];
}

- (void)presentChangeCurrencyAlertController {
    
    NSArray *currencies = @[NSLocalizedString(@"Phone's Currency", nil), @"$", @"€", @"£", @"₺"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSInteger i = 0; i < currencies.count; i++)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:currencies[i]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [ExpenseListLogic changeLocaleForCurrency:currencies[i]];
                                                           [self updateSliderLabelTexts];
                                                           self.headerAmountLabel.text = [self.logic currencyStringRepresentationOfAmount:[self.logic totalExpense]];
                                                           [self.tableView reloadData];
                                                       }];
        
        [alertController addAction:action];
    }
    
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self filterValueChanged:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES]; //dismiss keyboard
}

#pragma mark - Filter Value Helpers

- (void)loadFilterValues {
    
    self.amountSlider.value = [ExpenseListLogic getAmountSliderValue];
    self.dateSlider.value = [ExpenseListLogic getDateSliderValue];
    self.sortSegmentedControl.selectedSegmentIndex = [ExpenseListLogic getSortSegmentValue];
}

- (void)updateSliderLabelTexts {
    
    self.amountFilterLabel.text = [self amountSliderStringValue:self.amountSlider.value];
    self.dateFilterLabel.text = [ExpenseListViewController dateSliderStringValue:self.dateSlider.value];
}

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

- (NSString *)amountSliderStringValue:(NSInteger)sliderValue {
    
    if (sliderValue > 0)
    {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Greater than", nil), [self.logic currencyStringRepresentationWithoutDecimalsOfAmount:[ExpenseListViewController amountSliderValue:sliderValue]]];
    }
    else
    {
        return NSLocalizedString(@"All expenses", nil);
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
            return NSLocalizedString(@"This week", nil); //1 week
            break;
        case 2:
            return NSLocalizedString(@"2 weeks", nil); //2 weeks
            break;
        case 3:
            return NSLocalizedString(@"3 weeks", nil); //3 weeks
            break;
        case 4:
            return NSLocalizedString(@"This month", nil); //1 month
            break;
        case 5:
            return NSLocalizedString(@"2 months", nil); //2 months
            break;
        case 6:
            return NSLocalizedString(@"3 months", nil); //3 months
            break;
        case 7:
            return NSLocalizedString(@"6 months", nil); //6 months
            break;
        case 8:
            return NSLocalizedString(@"12 months", nil); //12 months
            break;
        default:
            return NSLocalizedString(@"All dates", nil); //all
            break;
    }
}

+ (SortingMethod)dateSegmentedControlValue:(NSInteger)selectedIndex {
    return selectedIndex;
}

#pragma mark - Helpers

- (void)fillCell:(ExpenseListTableViewCell *)cell expenseData:(Expense *)expense {
    
    cell.expenseLabel.text = [self.logic currencyStringRepresentationOfAmount:expense.amount];
    cell.descriptionLabel.text = expense.expenseDescription;
    cell.commentLabel.text = expense.comment;
    cell.dateLabel.text = [expense.date localeDateString];
}


@end

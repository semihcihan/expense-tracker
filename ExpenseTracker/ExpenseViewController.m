//
//  ExpenseViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ExpenseViewController.h"
#import "UIView+Loading.h"
#import <UIView+Toast.h>
#import "UITableView+Register.h"
#import "ExpenseTableViewCell.h"
#import "Expense.h"
#import "NSString+ExpenseTracker.h"
#import "NSDate+ExpenseTracker.h"

@interface ExpenseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *amountFilterLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateFilterLabel;
@property (strong, nonatomic) IBOutlet UISlider *amountSlider;
@property (strong, nonatomic) IBOutlet UISlider *dateSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *filterClearButton;
- (IBAction)filterClearButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@interface ExpenseTableViewCell (Data)

- (void)fillWithExpenseData:(Expense *)expense;

@end


@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Expenses";
    
    [self.tableView registerCellClassForDefaultReuseIdentifier:[ExpenseTableViewCell class]];
    
    self.logic = [[ExpenseLogic alloc] init];
    [self.view showLoadingView];
    [self getData];
}

- (void)getData {
    
    [self.logic getExpensesWithSuccessBlock:^(NSArray *expenses)
     {
         [self.view dismissLoadingView];
         [self.tableView reloadData];
     }
                               failureBlock:^(NSString *error)
     {
         [self.view dismissLoadingView];
         [self.view makeToast:error duration:2 position:CSToastPositionBottom];
     }];
}

- (IBAction)filterClearButtonTapped:(id)sender {
    
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logic.shownExpenses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpenseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ExpenseTableViewCell reuseIdentifier]];
    
    [cell fillWithExpenseData:self.logic.shownExpenses[indexPath.row]];
    
    return cell;
}


@end

@implementation ExpenseTableViewCell (Data)

- (void)fillWithExpenseData:(Expense *)expense {
    
    self.expenseLabel.text = [NSString stringWithFormat:@"%@ %@",[expense.amount stringValue], [NSString currencySymbol]];
    self.descriptionLabel.text = expense.expenseDescription;
    self.commentLabel.text = expense.comment;
    self.dateLabel.text = [expense.date localeDateString];
}

@end

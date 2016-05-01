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

@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view showLoadingView];
    self.navigationItem.title = @"Expenses";
    
    self.logic = [[ExpenseLogic alloc] init];
    [self getData];
}

- (void)getData {
    
    [self.logic getExpensesWithSuccessBlock:^(NSArray *expenses)
     {
         [self.view dismissLoadingView];
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end

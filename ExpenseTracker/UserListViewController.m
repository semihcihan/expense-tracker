//
//  UserListViewController.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "UserListViewController.h"
#import "NavigationBarStyler.h"
#import "UIView+Loading.h"
#import "UITableView+Register.h"
#import "UserListTableViewCell.h"
#import "AlertManager.h"
#import <UIView+Toast.h>
#import "ExpenseListViewController.h"
#import "UIColor+ExpenseTracker.h"

@interface UserListViewController () <ErrorActionProtocol, UITableViewDelegate, UITableViewDataSource, UserListTableViewCellDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.title = NSLocalizedString(@"Users", nil);
    [NavigationBarStyler styleRightNavigationItem:self.navigationItem
                                            image:[UIImage imageNamed:@"more"]
                                           target:self
                                           action:@selector(moreButtonTapped)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    [self.tableView registerCellClassForDefaultReuseIdentifier:[UserListTableViewCell class]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)getData {
    
    [self.view showLoadingView];
    
    [self.logic getUsersAndUserDetailsWithSuccessBlock:^(NSArray *usersAndUserDetails)
     {
         [self.view dismissLoadingView];
         [self.logic filterEmailsWithKeyword:self.searchBar.text];
         [self.tableView reloadData];
     }
                               failureBlock:^(NSString *error)
     {
         [self.view showErrorMessage:error actionMessage:NSLocalizedString(@"Tap to retry", nil) actionTarget:self];
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (sender && [sender isKindOfClass:[PFUser class]])
    {
        ExpenseListLogic *logic = [[ExpenseListLogic alloc] init];
        logic.user = sender;
        ((ExpenseListViewController *)segue.destinationViewController).logic = logic;
    }
    
}

#pragma mark - TableView Data Source Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logic.shownUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserListTableViewCell reuseIdentifier]];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    [self fillCell:cell user:self.logic.shownUsers[indexPath.row] userDetails:self.logic.shownUserDetails[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UserListTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.logic shouldShowExpensesOfUserDetails:self.logic.shownUserDetails[indexPath.row]])
    {
        PFUser *user = self.logic.shownUsers[indexPath.row];
        [self performSegueWithIdentifier:NSStringFromClass([ExpenseListViewController class]) sender:user];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.logic shouldShowExpensesOfUserDetails:self.logic.shownUserDetails[indexPath.row]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}
    
#pragma mark - Actions

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [refreshControl endRefreshing];
    [self getData];
}

- (void)errorViewTapped:(UIGestureRecognizer *)recognizer {
    
    [self.view dismissErrorView];
    [self getData];
}

- (void)moreButtonTapped {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionLogout = [UIAlertAction actionWithTitle:NSLocalizedString(@"Log Out", nil)
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [UserListLogic logout];
                                                             [ViewController goToOpeningViewController];
                                                         }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertController addAction:actionLogout];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.logic filterEmailsWithKeyword:self.searchBar.text];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
}

#pragma mark - UserListTableViewCellDelegate

- (void)banButtonTapped:(id)sender {
    
    NSInteger userIndex = ((UIView *)sender).tag;
    BOOL ban = !((UserDetails *)self.logic.shownUserDetails[userIndex]).banned;
    NSString *message = ban ? NSLocalizedString(@"Are you sure you want to ban this user?", nil) : NSLocalizedString(@"Are you sure you want to unban this user?", nil);
    NSString *buttonTitle = ban ? NSLocalizedString(@"Ban User", nil) : NSLocalizedString(@"Unban User", nil);
    
    [AlertManager showAlertWithTitle:nil
                             message:message
                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                   otherButtonTitles:@[buttonTitle]
                      viewController:self
                   completionHandler:^(NSInteger buttonClicked)
     {
         if (buttonClicked == 1)
         {
             [self.view showLoadingView];
             [self.logic banUser:self.logic.shownUsers[userIndex]
                          banned:ban
                     userDetails:self.logic.shownUserDetails[userIndex]
                    successBlock:^
             {
                 [self getData];
             }
                    failureBlock:^(NSString *error)
             {
                 [self.view makeToast:error duration:3 position:CSToastPositionBottom];
             }];
         }
     }];
    
}

#pragma mark - Helpers

- (void)fillCell:(UserListTableViewCell *)cell user:(PFUser *)user userDetails:(UserDetails *)userDetails {
    
    cell.emailLabel.text = user.username;
    if ([userDetails userRole] != UserRoleRegular)
    {
        [UIView performWithoutAnimation:^
        {
            [cell.banButton setTitle:([userDetails userRole] == UserRoleUserManager) ? NSLocalizedString(@"User Manager", nil) : NSLocalizedString(@"Admin", nil) forState:UIControlStateNormal];
            [cell.banButton layoutIfNeeded];
        }];
        cell.banButton.enabled = NO;
        [cell.banButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
    else
    {
        [UIView performWithoutAnimation:^
        {
            [cell.banButton setTitle:(userDetails.banned) ? NSLocalizedString(@"Unban User", nil) : NSLocalizedString(@"Ban User", nil) forState:UIControlStateNormal];
            [cell.banButton layoutIfNeeded];
        }];
        cell.banButton.enabled = YES;
        [cell.banButton setTitleColor:[UIColor mainBlueColor] forState:UIControlStateNormal];
    }
    
}

@end

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

@interface UserListViewController () <ErrorActionProtocol, UITableViewDelegate, UITableViewDataSource, UserListTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@interface UserListTableViewCell (Data)

- (void)fillWithUser:(PFUser *)user userDetails:(UserDetails *)userDetails;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.title = @"Users";
    [NavigationBarStyler styleRightNavigationItem:self.navigationItem
                                            image:[UIImage imageNamed:@"more"]
                                           target:self
                                           action:@selector(moreButtonTapped)];

    [self.tableView registerCellClassForDefaultReuseIdentifier:[UserListTableViewCell class]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view showLoadingView];
    [self getData];
}

- (void)getData {
    
    [self.logic getUsersAndUserDetailsWithSuccessBlock:^(NSArray *usersAndUserDetails)
     {
         [self.view dismissLoadingView];
         [self.tableView reloadData];
     }
                               failureBlock:^(NSString *error)
     {
         [self.view showErrorMessage:error actionMessage:@"Tap to retry" actionTarget:self];
     }];
}

#pragma mark - TableView Data Source Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logic.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserListTableViewCell reuseIdentifier]];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    [cell fillWithUser:self.logic.users[indexPath.row] userDetails:self.logic.userDetails[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UserListTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
    
#pragma mark - Actions

- (void)errorViewTapped:(UIGestureRecognizer *)recognizer {
    [self getData];
}

- (void)moreButtonTapped {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionLogout = [UIAlertAction actionWithTitle:@"Log Out"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [UserListLogic logout];
                                                             [ViewController goToOpeningViewController];
                                                         }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Close"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertController addAction:actionLogout];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UserListTableViewCellDelegate

- (void)banButtonTapped:(id)sender {
    
    [AlertManager showAlertWithTitle:nil
                             message:@"Are you sure you want to ban this user?"
                   cancelButtonTitle:@"Cancel"
                   otherButtonTitles:@[@"Ban User"]
                      viewController:self
                   completionHandler:^(NSInteger buttonClicked)
     {
         if (buttonClicked == 1)
         {
#warning ban user
         }
     }];
    
}

@end

#pragma mark - ExpenseTableViewCell (Data)


@implementation UserListTableViewCell (Data)

- (void)fillWithUser:(PFUser *)user userDetails:(UserDetails *)userDetails {
    
    self.emailLabel.text = user.username;
    if (userDetails.role)
    {
        NSString *roleName = ([userDetails.role.name isEqualToString:@"user_admin"]) ? @"User Manager" : @"Admin";
    
        [self.banButton setTitle:roleName forState:UIControlStateNormal];
        self.banButton.enabled = NO;
        [self.banButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.banButton setTitle:@"normalllll" forState:UIControlStateNormal];
    }
    
}

@end
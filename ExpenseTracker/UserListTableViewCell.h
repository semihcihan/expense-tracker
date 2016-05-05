//
//  UserListTableViewCell.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 05/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "TableViewCell.h"

@protocol UserListTableViewCellDelegate <NSObject>

- (void)banButtonTapped:(id)sender;

@end

@interface UserListTableViewCell : TableViewCell

+ (CGFloat)height;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIButton *banButton;
@property (weak, nonatomic) id<UserListTableViewCellDelegate> delegate;

@end

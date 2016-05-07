//
//  ExpenseTableViewCell.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 02/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"

@interface ExpenseListTableViewCell : TableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *expenseLabel;

+ (CGFloat)height;

@end

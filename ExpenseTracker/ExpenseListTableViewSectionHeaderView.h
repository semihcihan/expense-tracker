//
//  ExpenseTableViewSectionHeaderView.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 03/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseListTableViewSectionHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageAmountLabel;

+ (CGFloat)height;

@end

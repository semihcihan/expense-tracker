//
//  ExpenseViewController.h
//  ExpenseTracker
//
//  Created by Semih Cihan on 01/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "ViewController.h"
#import "ExpenseListLogic.h"

@interface ExpenseListViewController : ViewController

@property (strong, nonatomic) ExpenseListLogic *logic;

@end

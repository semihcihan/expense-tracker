//
//  UIView+NibLoading.m
//  ExpenseTracker
//
//  Created by Semih Cihan on 03/05/16.
//  Copyright © 2016 Semih Cihan. All rights reserved.
//

#import "UIView+NibLoading.h"

@implementation UIView (NibLoading)

+ (instancetype)loadFromNIB
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil];
    
    for (id view in nibViews)
    {
        if ([view isKindOfClass:[self class]])
        {
            return view;
        }
    }
    
    return nil;
}

@end

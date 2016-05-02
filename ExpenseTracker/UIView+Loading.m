//
//  UIView+Loading.m
//  Carbon
//
//  Created by Semih Cihan on 22/01/15.
//  Copyright (c) 2015 mobilike. All rights reserved.
//

#import "UIView+Loading.h"
#import "MBProgressHUD.h"

static const NSInteger kHudTag = 1899124;

@implementation UIView (Loading)

- (void)showLoadingView {
    if (![self viewWithTag:kHudTag]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [hud setTag:kHudTag];
    }
}

- (void)showLoadingViewWithCustomIndicatorColor:(UIColor *)indicatorColor {
    if (![self viewWithTag:kHudTag]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [hud setTag:kHudTag];
        hud.activityIndicatorColor = indicatorColor;
    }
}

- (void)dismissLoadingView {
    [MBProgressHUD hideHUDForView:self animated:NO];
}

- (void)dismissErrorView {
    [self dismissLoadingView];
}

- (void)showErrorMessage:(NSString *)errorMessage
           actionMessage:(NSString *)actionMessage
            actionTarget:(id<ErrorActionProtocol>)target {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        [self showLoadingView];
        hud = [MBProgressHUD HUDForView:self];
    }
    hud.mode = MBProgressHUDModeText;
    [hud setLabelText:errorMessage];
    if (actionMessage) {
        [hud setDetailsLabelText:actionMessage];
    }
    
    if (target) {
        for (UIGestureRecognizer *recognizer in hud.gestureRecognizers) {
            [hud removeGestureRecognizer:recognizer];
        }
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:target
                                                action:@selector(errorViewTapped:)];
        [hud addGestureRecognizer:singleFingerTap];
    }
}

@end

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
//        hud.color = [CBAppConfig sharedConfig].loadingBackgroundColor;
//        hud.activityIndicatorColor = [CBAppConfig sharedConfig].loadingIndicatorColor;
    }
}

- (void)showLoadingViewWithCustomIndicatorColor:(UIColor *)indicatorColor {
    if (![self viewWithTag:kHudTag]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [hud setTag:kHudTag];
//        hud.color = [CBAppConfig sharedConfig].loadingBackgroundColor;
        hud.activityIndicatorColor = indicatorColor;
    }
}

- (void)dismissLoadingView {
    [MBProgressHUD hideHUDForView:self animated:NO];
}

- (void)dismissErrorView {
    [self dismissLoadingView];
}

- (void)showErrorMessage:(NSString *)errorMessage actionTarget:(id<CBLoadingActionProtocol>)target {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        [self showLoadingView];
        hud = [MBProgressHUD HUDForView:self];
    }
//    hud.detailsLabelFont = [CBAppConfig sharedConfig].errorTextFont;
//    hud.detailsLabelColor = [CBAppConfig sharedConfig].errorTextColor;
    hud.mode = MBProgressHUDModeText;
    hud.opacity = 0.f;
    [hud setDetailsLabelText:errorMessage];
    
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

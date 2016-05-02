//
//  UIView+Loading.h
//  Carbon
//
//  Created by Semih Cihan on 22/01/15.
//  Copyright (c) 2015 mobilike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ErrorActionProtocol <NSObject>

- (void)errorViewTapped:(UIGestureRecognizer *)recognizer;

@end

@interface UIView (Loading)

/**
 Creates a loading view and adds it to self as a subview. Disables user interaction. Uses CBLoadingStyleConfig.
 */
- (void)showLoadingView;

/**
 Creates a loading view and adds it to self as a subview. Disables user interaction. Uses CBLoadingStyleConfig except for the activity indicator color.
 @param indicatorColor Custom activity indicator color.
 */
- (void)showLoadingViewWithCustomIndicatorColor:(UIColor *)indicatorColor;

/**
 Dismisses the loading view. Enables user interaction.
 */
- (void)dismissLoadingView;

/**
 Dismisses the error view. Enables user interaction.
 */
- (void)dismissErrorView;

/**
 Shows the given error message.
 @param errorMessage Message to be displayed on top.
 @param actionMessage Message to be displayed at the bottom.
 @param target Target of the errorViewTapped action.
 */
- (void)showErrorMessage:(NSString *)errorMessage
           actionMessage:(NSString *)actionMessage
            actionTarget:(id<ErrorActionProtocol>)target;

@end

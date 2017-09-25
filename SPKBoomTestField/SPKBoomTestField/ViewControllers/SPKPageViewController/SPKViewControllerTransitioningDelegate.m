//
//  SPKViewControllerTransitioningDelegate.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "SPKViewControllerTransitioningDelegate.h"

@implementation SPKViewControllerTransitioningDelegate

#pragma UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

//NS_AVAILABLE_IOS(8_0)
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return nil;
}

@end

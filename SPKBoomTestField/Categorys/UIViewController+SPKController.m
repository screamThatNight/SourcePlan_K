//
//  UIViewController+SPKController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "UIViewController+SPKController.h"

@implementation UIViewController (SPKController)

//由于项目的架构底层的确定的Navigation 再其次是作为其RootViewController的tabBarController 所以可以避免写递归
+ (UIViewController *)topViewController {
    UINavigationController *appRootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([appRootViewController.topViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)appRootViewController.topViewController;
        return tabBarController.selectedViewController;
    }
    return appRootViewController.topViewController;
}

- (void)showToastString:(NSString *)string type:(SPKToastType)type {
    [SPKToastView showWithDesc:string type:type];
}

@end

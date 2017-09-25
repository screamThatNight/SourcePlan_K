//
//  UIViewController+SPKController.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPKToastView.h"

@interface UIViewController (SPKController)

+ (UIViewController *)topViewController;

- (void)showToastString:(NSString *)string type:(SPKToastType)type;

@end

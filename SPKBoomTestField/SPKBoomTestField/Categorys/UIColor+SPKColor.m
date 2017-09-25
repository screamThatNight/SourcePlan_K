//
//  UIColor+SPKColor.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "UIColor+SPKColor.h"

@implementation UIColor (SPKColor)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(float)(1+arc4random()%99)/100.f  green:(float)(1+arc4random()%99)/100.f  blue:(float)(1+arc4random()%99)/100.f  alpha:1];
}

@end

//
//  UIImage+SPKImage.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "UIImage+SPKImage.h"
#import <objc/runtime.h>

@implementation UIImage (SPKImage)

+ (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.f, 1.f), NO, 1.f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, 1.f, 1.f));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size
                 lineWidth:(CGFloat)lineWidth
               borderColor:(UIColor *)borderColor
              cornerRadius:(CGFloat)radius
           backgroundColor:(UIColor *)color {
    if (!size.height || !size.width) {return nil;}
    if (radius > size.height/2) {radius = size.height/2;}
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextAddPath(ctx, path.CGPath);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillPath(ctx);
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

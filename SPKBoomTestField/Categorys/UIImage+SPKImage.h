//
//  UIImage+SPKImage.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SPKImage)

+ (UIImage *)imageWithColor:(UIColor *)color;

//绘制指定大小 背景色 圆角的 图像
+ (UIImage *)imageWithSize:(CGSize)size
                 lineWidth:(CGFloat)lineWidth
               borderColor:(UIColor *)borderColor
              cornerRadius:(CGFloat)radius
           backgroundColor:(UIColor *)color;

@end

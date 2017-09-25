//
//  UIButton+SPKButton.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "UIButton+SPKButton.h"

@implementation UIButton (SPKButton)

+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
             normalTitleColor:(UIColor *)normalTitleColor
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
             highlightedImage:(UIImage *)highlightedImage
                       target:(id)target
                     selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end

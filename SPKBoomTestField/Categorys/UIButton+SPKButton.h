//
//  UIButton+SPKButton.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SPKButton)

+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
             normalTitleColor:(UIColor *)normalTitleColor
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
             highlightedImage:(UIImage *)highlightedImage
                       target:(id)target
                     selector:(SEL)selector;

@end

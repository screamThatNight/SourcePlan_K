//
//  UILabel+SPKLabel.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 作为项目中使用最多的控件之一，Label内可发掘的点实在太多。该类后续当慢慢扩充
 label内
 */
@interface UILabel (SPKLabel)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color aliment:(NSTextAlignment)aliment;

@end

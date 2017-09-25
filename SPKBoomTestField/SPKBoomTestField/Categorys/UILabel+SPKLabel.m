//
//  UILabel+SPKLabel.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "UILabel+SPKLabel.h"

@implementation UILabel (SPKLabel)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color aliment:(NSTextAlignment)aliment {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = font;
    label.textColor = color;
    label.textAlignment = aliment;
    return label;
}

@end

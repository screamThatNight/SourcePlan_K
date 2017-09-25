//
//  NSString+SPKString.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SPKString)

- (CGSize)spk_sizeWithFont:(UIFont *)font;

- (CGFloat)spk_heightOfMaxWidth:(CGFloat)width font:(UIFont *)font;

- (CGFloat)spk_heightOfMaxWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing;

@end

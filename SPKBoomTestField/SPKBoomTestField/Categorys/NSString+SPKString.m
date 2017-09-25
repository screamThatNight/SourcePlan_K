//
//  NSString+SPKString.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "NSString+SPKString.h"

@implementation NSString (SPKString)

- (CGSize)spk_sizeWithFont:(UIFont *)font {
    return [self sizeWithAttributes:@{NSFontAttributeName : font}];
}

/*
 //指定的原点是线段原点，不是基线原点。
 NSStringDrawingUsesLineFragmentOrigin = 1 << 0, // The specified origin is the line fragment origin, not the base line origin
 
 //使用字体来计算高度
 NSStringDrawingUsesFontLeading = 1 << 1, // Uses the font leading for calculating line heights
 
 //利用图形边界而不是字形边界来计算高度
 NSStringDrawingUsesDeviceMetrics = 1 << 3, // Uses image glyph bounds instead of typographic bounds
 
 //如果文字不适合指定的bounds大小，就裁剪并且增加省略字符到最后一行可见的字中去。如果NSStringDrawingUsesLineFragmentOrigin也没有被设置就会忽略。
 NSStringDrawingTruncatesLastVisibleLine NS_ENUM_AVAILABLE(10_5, 6_0) = 1 << 5, // Truncates and adds the ellipsis character to the last visible line if the text doesn't fit into the bounds specified. Ignored if NSStringDrawingUsesLineFragmentOrigin is not also set.

 */
- (CGFloat)spk_heightOfMaxWidth:(CGFloat)width font:(UIFont *)font {
    return [self spk_heightOfMaxWidth:width font:font lineSpacing:0.f paragraphSpacing:0.f];
}

- (CGFloat)spk_heightOfMaxWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing {
    NSMutableDictionary *attributeDic = nil;
    if (lineSpacing || paragraphSpacing) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        if (lineSpacing) {
            paragraph.lineSpacing = lineSpacing;
        }
        if (paragraphSpacing) {
            paragraph.paragraphSpacing = paragraphSpacing;
        }
        [attributeDic setObject:paragraph forKey:NSParagraphStyleAttributeName];
    }
    if (font) {
        [attributeDic setObject:font forKey:NSFontAttributeName];
    }
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
    return ceil(size.height);
}

@end

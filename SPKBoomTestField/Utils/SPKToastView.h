//
//  SPKToastView.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPKToastType) {
    SPKToastTypeSuccess = 0,
    SPKToastTypeFail    = 1
};

/*
 负责项目内的提示语，先从支持成功提示与失败提示开始
 成功的情况下 背景色蓝色
 反之，失败为红色
 目前不考虑横竖屏 等实际场景到了再增加横竖屏
 */
@interface SPKToastView : UIView

+ (void)showWithDesc:(NSString *)desc type:(SPKToastType)type;

@end

//
//  SPKToastView.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "SPKToastView.h"
#import "UILabel+SPKLabel.h"
#import "NSString+SPKString.h"
#import "UIViewController+SPKController.h"

#define TOP_BOTTOM_SPACING (10.f)
#define TEXT_LINESPACING (3.f)

#define STRING_FONT ([UIFont systemFontOfSize:16.f])

@interface SPKToastView ()

@property (nonatomic) UILabel *descLabel;

@end

@implementation SPKToastView

+ (void)showWithDesc:(NSString *)desc type:(SPKToastType)type {
    if (!desc.length) {
        return;
    }
    SPKToastView *view = [[SPKToastView alloc] init];
    view.width = SCREEN_WIDTH;
    view.left = 0;
    view.backgroundColor = type == SPKToastTypeSuccess ? [[UIColor blueColor] colorWithAlphaComponent:0.5] : [[UIColor redColor] colorWithAlphaComponent:0.5];
    [view configureContentText:desc];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelAlert; //这行牛逼了，之后找个时间写个博客。 加了之后弹出的view不会被状态栏遮住了.
    [window insertSubview:view atIndex:window.subviews.count];
    
    [view animate];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _descLabel = [UILabel labelWithFont:STRING_FONT textColor:[UIColor whiteColor] aliment:NSTextAlignmentCenter];
        [self addSubview:_descLabel];
    }
    return self;
}

- (void)configureContentText:(NSString *)contentString {
    self.descLabel.width = SCREEN_WIDTH - 30;
    self.descLabel.height = [contentString spk_heightOfMaxWidth:self.descLabel.width font:self.descLabel.font lineSpacing:3.f paragraphSpacing:0.f];
    self.descLabel.left = 15;
    self.descLabel.top = TOP_BOTTOM_SPACING;
    self.descLabel.text = contentString;
    self.height = self.descLabel.bottom + TOP_BOTTOM_SPACING;
}

- (void)animate {
    self.top = -(self.height);
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f delay:2.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.top = -(self.height);
        } completion:^(BOOL finished) {
            //记得设置回去
            //默认0 alert 2000 statusBar 1000
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.windowLevel = 0;
            [self removeFromSuperview];
        }];
    }];
}

@end

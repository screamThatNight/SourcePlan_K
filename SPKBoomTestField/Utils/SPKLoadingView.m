//
//  SPKLoadingView.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/15.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "SPKLoadingView.h"

#define WIDTH (80)
#define HEIGHT (80)
#define CORN

@interface SPKLoadingView ()

@property (nonatomic) CAShapeLayer *loadingLayer;

@end

@implementation SPKLoadingView

+ (void)startLoading {
    SPKLoadingView *view = [[SPKLoadingView alloc] init];
    view.size = CGSizeMake(WIDTH, HEIGHT);
    view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    view.layer.cornerRadius = 10.f;
    view.layer.masksToBounds = YES;
    view.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

+ (void)endLoading {}

@end

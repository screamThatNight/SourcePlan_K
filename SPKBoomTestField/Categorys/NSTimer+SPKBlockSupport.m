//
//  NSTimer+SPKBlockSupport.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/11/16.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "NSTimer+SPKBlockSupport.h"

@implementation NSTimer (SPKBlockSupport)

//iOS10上已经提供了以block形式来避免循环引用的方式，但是iOS10之前均没有，还是需要自己写一个分类
//NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//}];

+ (NSTimer *)spk_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(spk_blockSupport:) userInfo:[block copy] repeats:repeats];
}

+ (void)spk_blockSupport:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end

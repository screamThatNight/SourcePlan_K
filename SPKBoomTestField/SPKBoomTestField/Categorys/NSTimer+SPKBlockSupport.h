//
//  NSTimer+SPKBlockSupport.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/11/16.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (SPKBlockSupport)

+ (NSTimer *)spk_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;

@end

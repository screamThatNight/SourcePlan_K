//
//  UIView+ExclusiveTouchSet.m
//  DKNetwork
//
//  Created by 刘康09 on 2017/8/30.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "UIView+ExclusiveTouchSet.h"
#import <objc/runtime.h>

@implementation UIView (ExclusiveTouchSet)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(didMoveToSuperview);
        SEL swizzledSelector = @selector(swizzled_didMoveToSuperview);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)swizzled_didMoveToSuperview {
    [self swizzled_didMoveToSuperview];
    self.exclusiveTouch = YES;
}

@end

//
//  UIView+FrameAdjust.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 用过Masonry的同学一定会对这里的上下左右理解有偏差，其实这里的上下左右，可以想象为Frame四方形图像的上下左右的线，分别代表线的位置而已，同理CenterX CenterY.
 */

@interface UIView (FrameAdjust)

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@end

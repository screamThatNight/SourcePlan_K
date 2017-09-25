//
//  SPKLoadingView.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/15.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 负责本app中loading的样式，为什么要写这样一个类内？
 1.一个页面的整体下拉刷新与加载更多依赖tableView 手势为向下拉 向上滑。
 2.toast提示目前采用从statueBar滑出的方式，但是不支持loading
 loading是必须的，网络请求的占位样式，以及居中的loadign也是必须的，在一些特殊场景下可以采取其他loading样式，但是一个居中的Loading是必须的。
 */
@interface SPKLoadingView : UIView

+ (void)startLoading;
+ (void)endLoading;

@end

//
//  HTLPageChildViewController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "HTLPageChildViewController.h"

@interface HTLPageChildViewController ()

@end

@implementation HTLPageChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"child - viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"child - viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"child - viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"child - viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"child - viewDidDisappear");
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    NSLog(@"child - willMoveToParentViewController parent : %@", parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    NSLog(@"child - didMoveToParentViewController parent : %@", parent);
}

- (void)removeFromParentViewController {
    [super removeFromParentViewController];
    NSLog(@"child - removeFromParentViewController parent");
}

#pragma mark - key

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated {
    [super beginAppearanceTransition:isAppearing animated:animated];
    if (animated) {
        //说明在动画过程中，不需要做处理
        return;
    }
    if (isAppearing) {
        //做出现预备工作 -> willAppear
        NSLog(@"%@ 即将出现", self);
    }
    else {
        //做消失预备工作 -> willDissAppear
        NSLog(@"%@ 即将消失", self);
    }
}

- (void)endAppearanceTransition {
    [super endAppearanceTransition];
    //做真正的操作 这里过渡结束 要么是彻底出现 要么是彻底消失
    NSLog(@"%@ 结束过渡", self);
}

@end

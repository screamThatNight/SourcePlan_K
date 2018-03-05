//
//  SPKSecondViewController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/10/26.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "SPKSecondViewController.h"

@interface SPKSecondViewController () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;

@end

@implementation SPKSecondViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.scrollView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn];
    
    btn.size = CGSizeMake(44, 100);
    btn.left = (SCREEN_WIDTH - 44)/2;
    btn.top = (SCREEN_HEIGHT - 100)/2;
}

- (void)btnClick:(id)sender {
    /*
     Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Application tried to present UIModalTransitionStylePartialCurl to or from non-fullscreen view controller <SPKSecondViewController: 0x7f8920101e30>.'
     */
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    UIView *testView = [[UIView alloc] init];
    testView.size = CGSizeMake(100, 100);
    testView.left = 100;
    testView.top = 100;
    testView.backgroundColor = [UIColor redColor];
    [vc.view addSubview:testView];
    
//    vc.modalTransitionStyle = UIModalTransitionStylePartialCurl; //负责modal动画 无关大雅
    
//    vc.modalPresentationStyle = UIModalPresentationFullScreen; //全屏
//    vc.modalPresentationStyle = UIModalPresentationPageSheet; //全屏？
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen; //如果视图没有被填满 底层视图可以透过
//    vc.modalPresentationStyle = UIModalPresentationCustom; //跟上面的原因一样 emm

//    vc.modalPresentationStyle = UIModalPresentationCustom; //自定制应该需要额外属性
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

//scrollView的方法 同样可以在代理中看到
//- (void)adjustedContentInsetDidChange {
//
//}

#pragma mark - UIScrollViewDelegate

//注意 没有设置contentSize的情况下不会触发，也就是说当contentSize值为CGSizeZero的时候是不会更新。应该是内部做了判断
// 如果当前的行为是 UIScrollViewContentInsetAdjustmentAutomatic 那么，如果scrollView的contentSize的高度不超过当前view的高度的时候，是不会更新adjustedContentInset的，也不会触发代理方法，也就是adjustedContentInset的值保持为UIEdgeInsetZero，当高度高于当前屏幕时，才会触发并且更新。
// UIScrollViewContentInsetAdjustmentAlways 无论contentSize多大都会适配并且更新adjustedContentInset
// UIScrollViewContentInsetAdjustmentNever 永远不要更新adjustedContentInset
// UIScrollViewContentInsetAdjustmentScrollableAxes 可滑动的情况下才更新

//注意注意
//与safeAreaInsets不同的是，safeAreaInsets仅仅是建议，是官方给予开发者做适配时的标准与建议，开发者可以不这么做，但是adjustedContentInset与contentInset是切实的会改变滚动视图内的子视图的排版的。在iOS11之前，滚动视图的内部交由contentInset来设置，但是到iOS11之后，设置滚动视图是一句adjustedContentInset来排版的，如果其公式可以近似的理解为 在iOS11之前，contentInset不设置的话默认就是UIEdgeInsetZero，但是在iOS11之后adjustedContentInset是会变的，其变化依据设置的滚动视图的contentInsetAdjustmentBehavior行为参数，滚动视图内部的排版也会根据实际的边距来。
//adjustedContentInset = safeAreaInset + contentInset

//tips：safeAreaInsets属性 是根据实际的view的frame来的，例如当view的top是20时，此时系统给出的safeAreaInset的top就会是68

//iOS11上新增的代理方法
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    //这个是针对内容
    NSLog(@"adjustedContentInset~~~%@~~~", NSStringFromUIEdgeInsets(self.scrollView.adjustedContentInset));
    NSLog(@"contentInset~~~%@~~~",NSStringFromUIEdgeInsets(self.scrollView.contentInset));
    
    //这个是针对view，而不是针对内容吧？ 想要监听一个view的safeAreaInsets变更，只能重写safeAreaInsetsDidChange方法了，这也是没办法的事。
    //这个safeAreaInset仅仅是建议边距，是留给开发者获取并且去适配的。系统不会帮忙做适配。因为这个值是可变的。
    NSLog(@"safeAreaInset%@", NSStringFromUIEdgeInsets(self.scrollView.safeAreaInsets));
    NSLog(@"contentLayoutGuide : %@", self.scrollView.contentLayoutGuide);
    NSLog(@"frameLayoutGuide : %@", self.scrollView.frameLayoutGuide);
}

/*
                                 adjustedContentInset.top
                                 contentInset.top
       aci.left    ci.left       ···                            ci.right  aci.right
                                 ···
                                 ···
                                 contentInset.bottom
                                 adjustedContentInset.top.bottom
 */

#pragma mark - getter or setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.size = self.view.size;
        _scrollView.top = 20;
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate = self;
        
        //不超过一屏幕的情况下 完全不会触发u 纠其原因 其跟里面的一些设置都有关
        _scrollView.contentSize = CGSizeMake(self.view.width, self.view.height+1);
        
        //Default is UIScrollViewContentInsetAdjustmentAutomatic.
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }
    return _scrollView;
}

@end

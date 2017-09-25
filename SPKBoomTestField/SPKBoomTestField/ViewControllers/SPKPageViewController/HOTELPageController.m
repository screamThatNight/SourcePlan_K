//
//  HOTELPageController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "HOTELPageController.h"
#import "HTLPageChildViewController.h"
#import "UIColor+SPKColor.h"

@interface HOTELPageController () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView; //纵观apple提供的方式，目前使用scrollView基本是最正确的做法了。

@property (nonatomic, readonly) NSInteger numberOfChildViewControllers;
@property (nonatomic, readonly) NSInteger defaultPageIndex;

@property (nonatomic, strong) UIViewController *currentViewController; //当前VC
@property (nonatomic) NSInteger currentIndex; //当前下标

@property (nonatomic) NSMutableDictionary *createChildDictionary;

@end

@implementation HOTELPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Father - viewDidLoad");
    self.currentIndex = self.defaultPageIndex;
    [self.view addSubview:self.scrollView];
}

- (void)dealloc {
    NSLog(@"pageController - dealloc");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.size = self.scrollView.size;
    }];
}

- (void)moveToIndex:(NSInteger)targetIndex {
    [self moveToIndex:targetIndex isOutSideControl:YES];
}

- (void)moveToIndex:(NSInteger)targetIndex isOutSideControl:(BOOL)isOutSizeControl {
    if (self.currentIndex == targetIndex) {
        return;
    }
    
    self.currentIndex = targetIndex;
    UIViewController *childVC = [self getChildViewControllerForIndex:self.currentIndex];
    if (isOutSizeControl) {
        [self.currentViewController beginAppearanceTransition:NO animated:NO];
        [childVC beginAppearanceTransition:YES animated:NO];
    }
    
    if (![self.createChildDictionary objectForKey:[NSString stringWithFormat:@"%@", @(self.currentIndex)]]) {
        [self addChildViewController:childVC];
        [childVC didMoveToParentViewController:self];
        
        childVC.view.size = CGSizeMake(self.scrollView.width, self.scrollView.height);
        childVC.view.left = childVC.view.width * self.currentIndex;
        childVC.view.top = 0;
        [self.scrollView addSubview:childVC.view];
        [self.createChildDictionary setObject:childVC forKey:[NSString stringWithFormat:@"%@", @(self.currentIndex)]];
    }
    if (isOutSizeControl) {
        [self.scrollView setContentOffset:CGPointMake(targetIndex * self.scrollView.width, 0) animated:NO];
    }
    
    [self.currentViewController endAppearanceTransition];
    [childVC endAppearanceTransition];
    
    self.currentViewController = childVC;
}

- (void)reload {
    [self.createChildDictionary removeAllObjects];
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj willMoveToParentViewController:nil];
        [obj removeFromParentViewController];
        [obj.view removeFromSuperview];
    }];

    self.currentIndex = self.defaultPageIndex;
    self.scrollView.contentSize = CGSizeMake(self.view.width * self.numberOfChildViewControllers, self.scrollView.height);
    
    UIViewController *defaultViewController = [self getChildViewControllerForIndex:self.defaultPageIndex];
    self.currentViewController = defaultViewController;
    [self addChildViewController:defaultViewController];
    [defaultViewController didMoveToParentViewController:self];
    defaultViewController.view.size = CGSizeMake(self.view.width, self.view.height);
    defaultViewController.view.left = defaultViewController.view.width * self.defaultPageIndex;
    defaultViewController.view.top = 0;
    [self.scrollView addSubview:defaultViewController.view];
    [self.createChildDictionary setValue:defaultViewController forKey:[NSString stringWithFormat:@"%@", @(self.currentIndex)]];
}

- (UIViewController *)getChildViewControllerForIndex:(NSInteger)index {
    if ([self.createChildDictionary objectForKey:[NSString stringWithFormat:@"%@", @(index)]]) {
        return [self.createChildDictionary objectForKey:[NSString stringWithFormat:@"%@", @(index)]];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageController:childViewControllerAtIndex:)]) {
        return [self.dataSource pageController:self childViewControllerAtIndex:index];
    }
    
    UIViewController *defaultViewController = [[UIViewController alloc] init];
    defaultViewController.view.backgroundColor = [UIColor randomColor];
    return defaultViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Father - viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Father - viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"Father - viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"Father - viewDidDisappear");
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x;
    if (offSetX <= 0 || offSetX >= self.scrollView.contentSize.width - self.scrollView.width) {
        return;
    }
    NSInteger rightIdx = (offSetX + self.scrollView.width) / self.scrollView.width;
    NSInteger leftIdx = offSetX / self.scrollView.width;
    CGFloat diff = (offSetX + self.scrollView.width) - rightIdx * self.scrollView.width;
    CGFloat rightScale = diff / self.scrollView.width;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:isMovingFromIndex:toIndex:processScale:)]) {
        [self.delegate pageController:self isMovingFromIndex:leftIdx toIndex:rightIdx processScale:rightScale];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x / self.scrollView.width);
    [self moveToIndex:index isOutSideControl:NO];
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(pageController:didMoveToIndex:)]) {
        [self.delegate pageController:self didMoveToIndex:index];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"3");
}

#pragma mark - private

#pragma mark - getter or setter

- (NSInteger)numberOfChildViewControllers {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfChildViewControllersInPageController:)]) {
        return [self.dataSource numberOfChildViewControllersInPageController:self];
    }
    return 0;
}

- (NSInteger)defaultPageIndex {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(defaultPageIndexInPageController:)]) {
        return [self.dataSource defaultPageIndexInPageController:self];
    }
    return 0;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor grayColor];
    }
    return _scrollView;
}

- (NSMutableDictionary *)createChildDictionary {
    if (!_createChildDictionary) {
        _createChildDictionary = @{}.mutableCopy;
    }
    return _createChildDictionary;
}

@end

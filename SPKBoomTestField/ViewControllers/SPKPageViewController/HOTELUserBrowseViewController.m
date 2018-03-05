//
//  HOTELUserBrowseViewController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "HOTELUserBrowseViewController.h"
#import "HOTELTagChoseView.h"
#import "HOTELPageController.h"
#import "HTLPageChildViewController.h"
#import "UIColor+SPKColor.h"

@interface HOTELUserBrowseViewController () <
HOTELTagChoseViewDataSource,
HOTELTagChoseViewDelegate,
HOTELPageControllerDataSource,
HOTELPageControllerDelegate
>

@property (nonatomic) HOTELTagChoseView *tagChoseView;
@property (nonatomic) NSMutableArray *titleArray;
@property (nonatomic) HOTELPageController *pageController;

@end

@implementation HOTELUserBrowseViewController

#pragma mark - life cycle

+ (void)load {
    //
    [super load];
    
    NSLog(@"222");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tagChoseView];

    self.pageController = [[HOTELPageController alloc] init];
    self.pageController.view.width = self.view.width;
    self.pageController.view.left = 0;
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [self addChildViewController:self.pageController];
    [self.pageController didMoveToParentViewController:self];
    [self.view addSubview:self.pageController.view];

    [self.tagChoseView reload];
    [self.pageController reload];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
}

//iOS11上的方法
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    //如果navigationBar与tabBar隐藏掉了，view的safeAreaInset还会考虑到这两个视图的偏移吗？
    //经过试验，当隐藏掉自己的navigationBar后，safeAreaInset不会包含navigationBar的高度。
    NSLog(@"%@", self.view.safeAreaLayoutGuide);
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 适用于所有版本的适配方法
    self.tagChoseView.top = self.view.spk_safeAreaInsets.top;
    self.pageController.view.top = self.tagChoseView.bottom;
    self.pageController.view.height = self.view.height - self.tagChoseView.height - self.view.spk_safeAreaInsets.top - self.view.spk_safeAreaInsets.bottom;
}

- (void)dealloc {
    NSLog(@"userCollection - dealloc");
}

#pragma mark - HOTELTagChoseViewDataSource

- (NSInteger)numberOfTagsInTagChoseView:(HOTELTagChoseView *)tagView {
    return self.titleArray.count;
}

- (NSString *)tagChoseView:(HOTELTagChoseView *)tagView nameOfTagAtIndex:(NSInteger)tagIndex {
    return self.titleArray[tagIndex];
}

- (NSInteger)defaultSelectedIndexInTagChoseView:(HOTELTagChoseView *)tagView {
    return 0;
}

#pragma mark - HOTELTagChoseViewDelegate

- (void)tagChoseView:(HOTELTagChoseView *)tagView didChoseTagAtIndex:(NSInteger)chosedIndex {
    [self.pageController moveToIndex:chosedIndex];
}

- (void)didClickMoreAtTagChoseView:(HOTELTagChoseView *)tagView {
    NSLog(@"more");
}

#pragma mark - HOTELPageControllerDataSource

- (NSInteger)numberOfChildViewControllersInPageController:(HOTELPageController *)pageController {
    return self.titleArray.count;
}

- (UIViewController *)pageController:(HOTELPageController *)pageController childViewControllerAtIndex:(NSInteger)index {
    HTLPageChildViewController *vc = [[HTLPageChildViewController alloc] init];
    vc.view.backgroundColor = [UIColor randomColor];
    return vc;
}

- (NSInteger)defaultPageIndexInPageController:(HOTELPageController *)pageController {
    return 0;
}

#pragma mark - HOTELPageControllerDelegate

- (void)pageController:(HOTELPageController *)pageController isMovingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex processScale:(CGFloat)scale {
    [self.tagChoseView leftIdx:fromIndex rightIdx:toIndex rightScale:scale];
}

- (void)pageController:(HOTELPageController *)pageController didMoveToIndex:(NSInteger)index {
    [self.tagChoseView didMoveToIndex:index];
}

#pragma mark - getter and setter

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"上海", @"南通", @"南京"]];
    }
    return _titleArray;
}

- (HOTELTagChoseView *)tagChoseView {
    if (!_tagChoseView) {
        _tagChoseView = [[HOTELTagChoseView alloc] init];
        _tagChoseView.size = CGSizeMake(self.view.size.width, 50);
        _tagChoseView.left = 0;
        _tagChoseView.dataSource = self;
        _tagChoseView.delegate = self;
    }
    return _tagChoseView;
}

@end

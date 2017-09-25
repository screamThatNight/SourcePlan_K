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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tagChoseView];
    
    self.pageController = [[HOTELPageController alloc] init];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    self.pageController.view.size = CGSizeMake(self.view.width, self.view.height - self.tagChoseView.height);
    self.pageController.view.top = self.tagChoseView.bottom;
    self.pageController.view.left = 0;
    [self addChildViewController:self.pageController];
    [self.pageController didMoveToParentViewController:self];
    [self.view addSubview:self.pageController.view];
    
    [self.tagChoseView reload];
    [self.pageController reload];
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
        _titleArray = [NSMutableArray arrayWithArray:@[@"上海", @"南通", @"南京", @"呼和浩特", @"普罗米修斯", @"罗", @"天堂与地狱", @"以撒的结合"]];
    }
    return _titleArray;
}

- (HOTELTagChoseView *)tagChoseView {
    if (!_tagChoseView) {
        _tagChoseView = [[HOTELTagChoseView alloc] init];
        _tagChoseView.size = CGSizeMake(self.view.size.width, 50);
        _tagChoseView.top = 64;
        _tagChoseView.left = 0;
        _tagChoseView.dataSource = self;
        _tagChoseView.delegate = self;
    }
    return _tagChoseView;
}

@end

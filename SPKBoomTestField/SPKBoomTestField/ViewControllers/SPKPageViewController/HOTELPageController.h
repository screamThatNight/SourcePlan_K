//
//  HOTELPageController.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HOTELPageController;

@protocol HOTELPageControllerDataSource <NSObject>

@required
- (NSInteger)numberOfChildViewControllersInPageController:(HOTELPageController *)pageController;
- (UIViewController *)pageController:(HOTELPageController *)pageController childViewControllerAtIndex:(NSInteger)index;

@optional
- (NSInteger)defaultPageIndexInPageController:(HOTELPageController *)pageController;

@end

@protocol HOTELPageControllerDelegate <NSObject>
@optional
- (void)pageController:(HOTELPageController *)pageController isMovingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex processScale:(CGFloat)scale;
- (void)pageController:(HOTELPageController *)pageController didMoveToIndex:(NSInteger)index;

@end

@interface HOTELPageController : UIViewController

@property (nonatomic, weak) id <HOTELPageControllerDataSource> dataSource;
@property (nonatomic, weak) id <HOTELPageControllerDelegate> delegate;

@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, readonly) NSInteger currentIndex;

- (void)moveToIndex:(NSInteger)targetIndex;
- (void)reload;

@end

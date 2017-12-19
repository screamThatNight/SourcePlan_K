//
//  HOTELTagChoseView.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HOTELTagChoseView;

@protocol HOTELTagChoseViewDataSource <NSObject>
@required
- (NSInteger)numberOfTagsInTagChoseView:(HOTELTagChoseView *)tagView;
- (NSString *)tagChoseView:(HOTELTagChoseView *)tagView nameOfTagAtIndex:(NSInteger)tagIndex;

@optional
- (NSInteger)defaultSelectedIndexInTagChoseView:(HOTELTagChoseView *)tagView;

@end

@protocol HOTELTagChoseViewDelegate <NSObject>
@optional
//如果正常字体大于选中字体，是没有字体切换特效的
- (CGFloat)titleNormalStateFontSizeInTagChoseView:(HOTELTagChoseView *)tagView;
- (CGFloat)titleSelectedStateFontSizeInTagChoseView:(HOTELTagChoseView *)tagView;
- (UIColor *)titleNormalStateColorInTagChoseView:(HOTELTagChoseView *)tagView;
- (UIColor *)titleSelectedStateColorInTagChoseView:(HOTELTagChoseView *)tagView;
- (void)tagChoseView:(HOTELTagChoseView *)tagView didChoseTagAtIndex:(NSInteger)chosedIndex;
- (void)didClickMoreAtTagChoseView:(HOTELTagChoseView *)tagView;
- (CGFloat)spacingBetweenTagsInTagChoseView:(HOTELTagChoseView *)tagView;

@end

@interface HOTELTagChoseView : UIView

@property (nonatomic, readonly) NSInteger selectedIndex;

@property (nonatomic, weak) id <HOTELTagChoseViewDataSource> dataSource;
@property (nonatomic, weak) id <HOTELTagChoseViewDelegate> delegate;

- (void)leftIdx:(NSInteger)leftIdx rightIdx:(NSInteger)rightIdx rightScale:(CGFloat)scale;
- (void)didMoveToIndex:(NSInteger)index;
- (void)reload;

@end

//
//  HOTELTagChoseView.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "HOTELTagChoseView.h"
#import "NSString+SPKString.h"

#define TAG_OFFSET (10086)
#define TITLE_LEFTRIGHT_PADDING (5.f)
#define BUTTON_FONT_ARRAY_COUNT (20)

@interface HOTELTagChoseView ()

@property (nonatomic, readonly) NSInteger numberOfTags;
@property (nonatomic, readonly) NSInteger defaultTagIndex;
@property (nonatomic, readonly) CGFloat spaing;
@property (nonatomic, readonly) CGFloat normalFontSize;
@property (nonatomic, readonly) CGFloat selectedFontSize;
@property (nonatomic, readonly) UIColor *normalColor;
@property (nonatomic, readonly) UIColor *selectedColor;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) UIButton *selectedButton;
@property (nonatomic) NSMutableArray *tagButtonArray;

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIButton *moreButton;
@property (nonatomic) UIView *slideLineView;

@property (nonatomic) NSMutableArray *buttonFontArray;
@property (nonatomic) NSMutableArray *scaleSegmentArray;

@end

@implementation HOTELTagChoseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.moreButton];
        [self.scrollView addSubview:self.slideLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.moreButton.size = CGSizeMake(44.f, self.height);
    self.moreButton.right = self.width;
    self.moreButton.top = (self.height - self.moreButton.height)/2;
    self.scrollView.size = CGSizeMake(self.width - self.moreButton.width, self.height);
    self.scrollView.left = 0;
    self.scrollView.top = 0;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.height);
    
    UIButton *lastButton = nil;
    for (NSInteger i = 0; i < self.tagButtonArray.count; i++) {
        UIButton *tagButton = self.tagButtonArray[i];
        tagButton.height = self.scrollView.height;
        tagButton.left = i == 0 ? TITLE_LEFTRIGHT_PADDING : lastButton.right + self.spaing;
        tagButton.top = 0;
        lastButton = tagButton;
    }
    
    self.slideLineView.height = 5;
    self.slideLineView.width = self.selectedButton.width;
    self.slideLineView.bottom = self.scrollView.height;
    self.slideLineView.centerX = self.selectedButton.centerX;
}

- (void)leftIdx:(NSInteger)leftIdx rightIdx:(NSInteger)rightIdx rightScale:(CGFloat)scale {
    if (!self.tagButtonArray.count) {
        return;
    }
    
    UIButton *rightButton = self.tagButtonArray[rightIdx];
    UIButton *leftButton = self.tagButtonArray[leftIdx];
    
    //创建的大量font 并不会被实时释放 造成大量的内存泄露。解决方案是预先创建好使用的UIButton，在reload期间重新创建删除
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat _normalR, _normalG, _normalB;
        CGFloat _selectedR, _selectedG, _selectedB;
        CGFloat _offsetR, _offsetG, _offsetB;
        
        [self.normalColor getRed:&_normalR green:&_normalG blue:&_normalB alpha:nil];
        [self.selectedColor getRed:&_selectedR green:&_selectedG blue:&_selectedB alpha:nil];
        
        _offsetR = _selectedR - _normalR;
        _offsetG = _selectedG - _normalG;
        _offsetB = _selectedB - _normalB;
        
        UIColor *rightColor = [UIColor colorWithRed:(_normalR + scale * _offsetR) green:(_normalG + scale * _offsetG) blue:(_normalB + scale * _offsetB) alpha:1];
        UIColor *leftColor = [UIColor colorWithRed:(_normalR + (1 - scale) * _offsetR) green:(_normalG + (1 - scale) * _offsetG) blue:(_normalB + (1 - scale) * _offsetB) alpha:1];
    
        UIFont *rightFont = self.buttonFontArray[[self p_fontIndexOfScale:scale]];
        UIFont *leftFont = self.buttonFontArray[[self p_fontIndexOfScale:1-scale]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
            [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
            rightButton.titleLabel.font = rightFont;
            leftButton.titleLabel.font = leftFont;
        });
    });
    
    CGFloat centerXOffset = rightButton.centerX - leftButton.centerX;
    self.slideLineView.centerX = leftButton.centerX + centerXOffset * scale;

    CGFloat buttonWidthOffset = rightButton.width - leftButton.width;
    if (fabs(buttonWidthOffset)) {
        self.slideLineView.width = leftButton.width + buttonWidthOffset * scale;
    }
}

- (NSInteger)p_fontIndexOfScale:(CGFloat)scale {
    if (scale == 0) {return 0;}
    if (scale == 1) {return BUTTON_FONT_ARRAY_COUNT-1;}
    for (NSInteger i = 0; i < self.scaleSegmentArray.count; i++) {
        CGFloat nowScale = [self.scaleSegmentArray[i] floatValue];
        if (scale < nowScale) {return 0;}
        if (scale == nowScale) {return i;}
        if (i < self.scaleSegmentArray.count - 1) {
            CGFloat nextScale = [self.scaleSegmentArray[i+1] floatValue];
            if (scale < nextScale) {return i;}
            if (scale == nextScale) {return i+1;}
        }
    }
    return BUTTON_FONT_ARRAY_COUNT-1;
}

- (void)didMoveToIndex:(NSInteger)index {
    for (UIButton *button in self.tagButtonArray) {
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:self.normalFontSize];
    }
    
    [self.selectedButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:self.normalFontSize];
    
    UIButton *toButton = self.tagButtonArray[index];
    [toButton setTitleColor:self.selectedColor forState:UIControlStateNormal];
    toButton.titleLabel.font = [UIFont systemFontOfSize:self.selectedFontSize];
    self.selectedButton = toButton;
    self.slideLineView.width = self.selectedButton.width;
    self.slideLineView.centerX = self.selectedButton.centerX;
    
    [self resetContentOffset];
}

- (void)reload {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.tagButtonArray removeAllObjects];
    
    [self.buttonFontArray removeAllObjects];
    [self.scaleSegmentArray removeAllObjects];
    if (self.normalFontSize < self.selectedFontSize) {
        CGFloat buttonOffset = self.selectedFontSize - self.normalFontSize;
        CGFloat avergeButtonOffset = buttonOffset / BUTTON_FONT_ARRAY_COUNT;
        
        for (CGFloat i = self.normalFontSize; i <= self.selectedFontSize; i+=avergeButtonOffset) {
            UIFont *font = [UIFont systemFontOfSize:i];
            [self.buttonFontArray addObject:font];
        }
        
        CGFloat scaleSegmentValue = 1.0/BUTTON_FONT_ARRAY_COUNT;
        for (CGFloat i = 0.f; i <= 1.0; i+=scaleSegmentValue) {
            [self.scaleSegmentArray addObject:[NSString stringWithFormat:@"%.2f", i]];
        }
    }
    
    CGFloat contentWidth = 0;
    for (NSInteger i = 0; i < self.numberOfTags; i++) {
        NSString *tagName = @"default";
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(tagChoseView:nameOfTagAtIndex:)]) {
            tagName = [self.dataSource tagChoseView:self nameOfTagAtIndex:i];
        }
        CGFloat tagWidth = [tagName spk_sizeWithFont:[UIFont systemFontOfSize:self.selectedFontSize]].width;
        tagWidth = MAX(44, tagWidth);
        contentWidth += (i == self.numberOfTags - 1 ? tagWidth : tagWidth + self.spaing);
        
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagButton.width = tagWidth;
        tagButton.tag = i + TAG_OFFSET;
        tagButton.titleLabel.font = [UIFont systemFontOfSize:self.normalFontSize];
        [tagButton setTitle:tagName forState:UIControlStateNormal];
        [tagButton setTitleColor:self.normalColor forState:UIControlStateNormal];
        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:tagButton];
        [self.tagButtonArray addObject:tagButton];
        
        if (i == self.defaultTagIndex) {
            tagButton.titleLabel.font = [UIFont systemFontOfSize:self.selectedFontSize];
            [tagButton setTitleColor:self.selectedColor forState:UIControlStateNormal];
            self.selectedIndex = i;
            self.selectedButton = tagButton;
        }
    }
    [self.scrollView setContentSize:CGSizeMake(contentWidth + TITLE_LEFTRIGHT_PADDING*2, 0)];
    [self.scrollView addSubview:self.slideLineView];
}

#pragma mark - event response

- (void)moreButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMoreAtTagChoseView:)]) {
        [self.delegate didClickMoreAtTagChoseView:self];
    }
}

- (void)tagButtonClick:(UIButton *)button {
    [self.selectedButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:self.normalFontSize];
    
    [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:self.selectedFontSize];
    
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.slideLineView.width = self.selectedButton.width;
        self.slideLineView.centerX = self.selectedButton.centerX;
    } completion:^(BOOL finished) {}];
    
    [self resetContentOffset];
    
    NSInteger tag = button.tag - TAG_OFFSET;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagChoseView:didChoseTagAtIndex:)]) {
        [self.delegate tagChoseView:self didChoseTagAtIndex:tag];
    }
}

- (void)resetContentOffset {
    if ((self.selectedButton.centerX > self.scrollView.width/2) && (self.selectedButton.centerX < (self.scrollView.contentSize.width - self.scrollView.width/2))) {
        [self.scrollView setContentOffset:CGPointMake(self.selectedButton.centerX - self.scrollView.width/2, 0) animated:YES];
    }
    else {
        CGFloat offSetX = (self.selectedButton.centerX > self.scrollView.width/2) ? self.scrollView.contentSize.width - self.scrollView.width : 0;
        [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    }
}

#pragma mark - setter or getter

- (NSInteger)numberOfTags {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfTagsInTagChoseView:)]) {
        return [self.dataSource numberOfTagsInTagChoseView:self];
    }
    return 10;
}

- (CGFloat)spaing {
    if (self.delegate && [self.delegate respondsToSelector:@selector(spacingBetweenTagsInTagChoseView:)]) {
        return [self.delegate spacingBetweenTagsInTagChoseView:self];
    }
    return 5.f;
}

- (NSInteger)defaultTagIndex {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(defaultSelectedIndexInTagChoseView:)]) {
        return [self.dataSource defaultSelectedIndexInTagChoseView:self];
    }
    return 0;
}

- (CGFloat)normalFontSize {
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleNormalStateFontSizeInTagChoseView:)]) {
        return [self.delegate titleNormalStateFontSizeInTagChoseView:self];
    }
    return 18.f;
}

- (CGFloat)selectedFontSize {
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleSelectedStateFontSizeInTagChoseView:)]) {
        return [self.delegate titleSelectedStateFontSizeInTagChoseView:self];
    }
    return 22.f;
}

- (UIColor *)normalColor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleNormalStateColorInTagChoseView:)]) {
        return [self.delegate titleNormalStateColorInTagChoseView:self];
    }
    return [UIColor blackColor];
}

- (UIColor *)selectedColor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleSelectedStateColorInTagChoseView:)]) {
        return [self.delegate titleSelectedStateColorInTagChoseView:self];
    }
    return [UIColor redColor];
}

- (NSMutableArray *)tagButtonArray {
    if (!_tagButtonArray) {
        _tagButtonArray = @[].mutableCopy;
    }
    return _tagButtonArray;
}

- (NSMutableArray *)buttonFontArray {
    if (!_buttonFontArray) {
        _buttonFontArray = @[].mutableCopy;
    }
    return _buttonFontArray;
}

- (NSMutableArray *)scaleSegmentArray {
    if (!_scaleSegmentArray) {
        _scaleSegmentArray = @[].mutableCopy;
    }
    return _scaleSegmentArray;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"M" forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        [_moreButton setBackgroundColor:[UIColor redColor]];
        [_moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)slideLineView {
    if (!_slideLineView) {
        _slideLineView = [[UIView alloc] init];
        _slideLineView.backgroundColor = [UIColor redColor];
    }
    return _slideLineView;
}

@end

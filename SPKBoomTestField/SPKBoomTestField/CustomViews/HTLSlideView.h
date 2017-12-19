//
//  SPKSlidePriceView.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/18.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HTLSliderControlMoveBlock)(CGFloat moveOffset);

@interface HTLSliderControl : UIView

//default is nil
@property (nonatomic) UIImage *normalImage;

//default is nill
@property (nonatomic) UIImage *highlightedImage;

@property (nonatomic, copy) HTLSliderControlMoveBlock moveBlock;

@end



typedef NS_ENUM(NSInteger, HTLSlideViewType) {
    HTLSlideViewTypeSingleControl = 0, //just one SlideControl to use
    HTLSlideViewTypeTwoControls   = 1  //two controls to use
};

typedef void(^HTLSlideViewMoveBlock)(CGFloat minValue, CGFloat maxValue);

@interface HTLSlideView : UIView

//default is grayColor.
@property (nonatomic) UIColor *progressNormalColor;

//default is redColor.
@property (nonatomic) UIColor *progressTintColor;

//default is 10.f
@property (nonatomic) CGFloat progressHeight;

//default is (CGSize)(44, 44)
@property (nonatomic) CGSize controlSize;

//default is nil
@property (nonatomic) UIImage *controlNormalImage;

//default is nil
@property (nonatomic) UIImage *controlHighlightedImage;

//defualt is 100 + 1, (value 1 present for "100+").
@property (nonatomic) CGFloat displayedMaxValue;

//origin displayed minValue, default is Zero.
@property (nonatomic) CGFloat defaultMinValue;

//origin displayed maxValue, default is displayedMaxValue.
@property (nonatomic) CGFloat defaultMaxValue;

//current min max value
@property (nonatomic, readonly) CGFloat currentMinValue;
@property (nonatomic, readonly) CGFloat currentMaxValue;
@property (nonatomic, copy) HTLSlideViewMoveBlock slideMoveBlock;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame type:(HTLSlideViewType)type NS_DESIGNATED_INITIALIZER;

@end




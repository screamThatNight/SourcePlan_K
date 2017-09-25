//
//  SPKSlidePriceView.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/18.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SPKSliderControlMoveBlock)(CGFloat moveOffset);

@interface SPKSliderControl : UIView

//default is nil
@property (nonatomic) UIImage *normalImage;

//default is nill
@property (nonatomic) UIImage *highlightedImage;

@property (nonatomic, copy) SPKSliderControlMoveBlock moveBlock;

@end



typedef NS_ENUM(NSInteger, SPKSlideViewType) {
    SPKSlideViewTypeSingleControl = 0, //just one SlideControl to use
    SPKSlideViewTypeTwoControls   = 1  //two controls to use
};

typedef void(^SPKSlideViewMoveBlock)(CGFloat minValue, CGFloat maxValue);

@interface SPKSlideView : UIView

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
@property (nonatomic, copy) SPKSlideViewMoveBlock slideMoveBlock;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame type:(SPKSlideViewType)type NS_DESIGNATED_INITIALIZER;

@end




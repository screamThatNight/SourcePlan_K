//
//  SPKSlidePriceView.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/18.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "SPKSlideView.h"
#import "UIColor+SPKColor.h"

#pragma mark - SPKSliderControl

@implementation SPKSliderControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint previousLocation = [touch previousLocationInView:self];
    CGPoint currentLocation = [touch locationInView:self];
    CGFloat moveOffset = currentLocation.x - previousLocation.x;
    if (self.moveBlock) {
        self.moveBlock(moveOffset);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches {NSLog(@"touchesEstimatedPropertiesUpdated");}

@end



#pragma mark - SPKSlidePriceView

@interface SPKSlideView ()

@property (nonatomic) CAShapeLayer *sliderProgressLayer; // display in back
@property (nonatomic) CAShapeLayer *tintLayer;
@property (nonatomic) NSMutableArray *controlsArray;
@property (nonatomic) NSMutableArray *tipsArray;
@property (nonatomic) CGFloat currentMinValue;
@property (nonatomic) CGFloat currentMaxValue;

@end

@implementation SPKSlideView

- (instancetype)initWithFrame:(CGRect)frame type:(SPKSlideViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        
        // set property to default values
        _progressNormalColor = [UIColor grayColor];
        _progressTintColor = [UIColor redColor];
        _progressHeight = 10.f;
        _controlSize = CGSizeMake(44, 44);
        _displayedMaxValue = 100.f + 1.f;
        _defaultMinValue = 0.f;
        _defaultMaxValue = 100.f + 1.f;
        _controlsArray = @[].mutableCopy;
        _tipsArray = @[].mutableCopy;
        _currentMinValue = _defaultMinValue;
        _currentMaxValue = _defaultMaxValue;
        
        //init subviews
        _sliderProgressLayer = [[CAShapeLayer alloc] init];
        _sliderProgressLayer.backgroundColor = [UIColor grayColor].CGColor;
        [self.layer addSublayer:_sliderProgressLayer];
        
        _tintLayer = [[CAShapeLayer alloc] init];
        _tintLayer.backgroundColor = [UIColor redColor].CGColor;
        [_sliderProgressLayer addSublayer:_tintLayer];
        
        SPKSliderControl *firstControl = [self p_createControl];
        [self addSubview:firstControl];
        [_controlsArray addObject:firstControl];
        
        UILabel *firstTipLabel = [self p_createTipLabel];
        [self addSubview:firstTipLabel];
        firstTipLabel.text = [NSString stringWithFormat:@"%.f", _currentMaxValue];
        [_tipsArray addObject:firstTipLabel];
        
        if (type == SPKSlideViewTypeTwoControls) {
            SPKSliderControl *secondControl = [self p_createControl];
            [self addSubview:secondControl];
            [_controlsArray addObject:secondControl];
            
            UILabel *secondeTipLabel = [self p_createTipLabel];
            [self addSubview:secondeTipLabel];
            [_tipsArray addObject:secondeTipLabel];
            
            firstTipLabel.text = [NSString stringWithFormat:@"%.f", _currentMinValue];
            secondeTipLabel.text = [NSString stringWithFormat:@"%.f", _currentMaxValue];
        }
        
        [self.layer setNeedsDisplay];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    //reset layers frame
    self.sliderProgressLayer.frame = CGRectMake(self.controlSize.width/2, (self.height - self.progressHeight)/2, self.width - self.controlSize.width, self.progressHeight);
    self.tintLayer.frame = CGRectMake(0, (self.sliderProgressLayer.frame.size.height - self.progressHeight)/2, 0, self.progressHeight);
    [self p_updateColors];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (SPKSliderControl *control in self.controlsArray) {
        control.size = self.controlSize;
        control.top = (self.height - self.controlSize.height)/2;
    }
    CGFloat pointScale = (CGFloat)(self.width - self.controlSize.width)/(CGFloat)self.displayedMaxValue;
    //reset controls frame
    SPKSliderControl *firstControl = [self.controlsArray firstObject];
    firstControl.left = self.currentMaxValue * pointScale;
    if (self.controlsArray.count == 2) {
        SPKSliderControl *secondeControl = self.controlsArray[1];
        firstControl.left = self.currentMinValue * pointScale;
        secondeControl.left = self.currentMaxValue * pointScale;
    }
    [self p_updateTipsLayout];
}


#pragma mark - private

- (SPKSliderControl *)p_createControl {
    __weak typeof(self)ws = self;
    SPKSliderControl *sliderControl = [[SPKSliderControl alloc] init];
    sliderControl.backgroundColor = [UIColor randomColor];
    sliderControl.layer.cornerRadius = self.controlSize.height/2;
    sliderControl.layer.masksToBounds = YES;
    __weak typeof(sliderControl)wse = sliderControl;
    sliderControl.moveBlock = ^(CGFloat moveOffset) {
        __strong typeof(wse)sse = wse;
        __strong typeof(ws)ss = ws;
        
        CGRect frame = sse.frame;
        frame.origin.x += moveOffset;
        if (frame.origin.x <= 0) {
            frame.origin.x = 0;
        }
        if (frame.origin.x >= self.width - self.controlSize.width) {
            frame.origin.x = self.width - self.controlSize.width;
        }
        sse.frame = frame;
        
        //update colors
        [ss p_updateColors];
        [ss p_updateTipsLayout];
    };
    return sliderControl;
}

- (UILabel *)p_createTipLabel {
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    tipLabel.size = CGSizeMake(44, 20);
    tipLabel.layer.cornerRadius = 5.f;
    tipLabel.layer.masksToBounds = YES;
    tipLabel.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    tipLabel.font = [UIFont systemFontOfSize:12.f];
    tipLabel.top = -15;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    return tipLabel;
}

- (void)p_updateColors {
    if (!self.controlsArray.count) {
        return;
    }
    
    SPKSliderControl *control = [self.controlsArray firstObject];
    CGFloat startX = 0;
    CGFloat endX = control.centerX - self.controlSize.width/2;
    
    if (self.controlsArray.count == 2) {
        SPKSliderControl *seconde = self.controlsArray[1];
        startX = MIN(control.centerX - self.controlSize.width/2, seconde.centerX - self.controlSize.width/2);
        endX = MAX(control.centerX - self.controlSize.width/2, seconde.centerX - self.controlSize.width/2);
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGRect frame = _tintLayer.frame;
    frame.origin.x = startX;
    frame.size.width = endX - startX;
    _tintLayer.frame = frame;
    [CATransaction commit];
    
    CGFloat width = (CGFloat)(self.width - self.controlSize.width);
    self.currentMinValue = (startX / width) * self.displayedMaxValue;
    self.currentMaxValue = (endX / width) * self.displayedMaxValue;
    if (self.slideMoveBlock) {
        self.slideMoveBlock(self.currentMinValue, self.currentMaxValue);
    }
}

- (void)p_updateTipsLayout {
    SPKSliderControl *firstControl = [self.controlsArray firstObject];
    SPKSliderControl *secondeControl = self.controlsArray.count > 1 ? self.controlsArray[1] : nil;
    UILabel *firstTipLabel = [self.tipsArray firstObject];
    UILabel *secondTipLabel = self.tipsArray.count > 1 ? self.tipsArray[1] : nil;
    
    firstTipLabel.centerX = firstControl.centerX;
    secondTipLabel.centerX = secondeControl.centerX;
    
    //update tips content
    if (!secondTipLabel) {
        firstTipLabel.text = [NSString stringWithFormat:@"%.f", self.currentMaxValue];
    }
    else {
        if (firstTipLabel.left <= secondTipLabel.left) {
            firstTipLabel.text = [NSString stringWithFormat:@"%.f", self.currentMinValue];
            secondTipLabel.text = [NSString stringWithFormat:@"%.f", self.currentMaxValue];
        }
        else {
            firstTipLabel.text = [NSString stringWithFormat:@"%.f", self.currentMaxValue];
            secondTipLabel.text = [NSString stringWithFormat:@"%.f", self.currentMinValue];
        }
    }
}

#pragma mark - setter and getter

- (void)setProgressNormalColor:(UIColor *)progressNormalColor {
    _progressNormalColor = progressNormalColor;
    self.sliderProgressLayer.backgroundColor = progressNormalColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    self.tintLayer.backgroundColor = progressTintColor.CGColor;
}

- (void)setProgressHeight:(CGFloat)progressHeight {
    _progressHeight = progressHeight;
    [self.layer setNeedsDisplay];
}

- (void)setControlSize:(CGSize)controlSize {
    _controlSize = controlSize;
    [self setNeedsDisplay];
}

- (void)setDisplayedMaxValue:(CGFloat)displayedMaxValue {
    _displayedMaxValue = displayedMaxValue > 0 ? displayedMaxValue : 100.f;
    if (displayedMaxValue < self.defaultMaxValue) {
        self.defaultMaxValue = displayedMaxValue;
    }
    [self.layer setNeedsDisplay];
    [self setNeedsDisplay];
}

- (void)setDefaultMaxValue:(CGFloat)defaultMaxValue {
    NSAssert(defaultMaxValue <= self.displayedMaxValue, @"默认最大值不允许设置比最大值大，请先修改最大值。");
    _defaultMaxValue = defaultMaxValue > 0 ? defaultMaxValue : 100.f;
    self.currentMaxValue = defaultMaxValue;
    [self setNeedsDisplay];
    [self p_updateTipsLayout];
}

- (void)setDefaultMinValue:(CGFloat)defaultMinValue {
    NSAssert(defaultMinValue <= self.defaultMaxValue, @"最小值请设置的比最大值小");
    _defaultMinValue = defaultMinValue > 0 ? defaultMinValue : 0.f;
    self.currentMinValue = defaultMinValue;
    [self setNeedsDisplay];
    [self p_updateTipsLayout];
}

- (void)setControlNormalImage:(UIImage *)controlNormalImage {
    for (SPKSliderControl *control in self.controlsArray) {
        control.normalImage = controlNormalImage;
    }
}

- (void)setControlHighlightedImage:(UIImage *)controlHighlightedImage {
    for (SPKSliderControl *control in self.controlsArray) {
        control.highlightedImage = controlHighlightedImage;
    }
}

@end


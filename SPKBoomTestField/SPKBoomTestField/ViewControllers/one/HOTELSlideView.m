//
//  HOTELSlideView.m
//  HotelBusiness
//
//  Created by 刘康09 on 2017/10/18.
//

#import "HOTELSlideView.h"
//#import "UIImage+Hotel.h"

#pragma mark - HOTELSliderControl
typedef void(^HOTELSliderControlMoveBlock)(CGFloat moveOffset);
@interface HOTELSliderControl : UIView
@property (nonatomic, copy) HOTELSliderControlMoveBlock moveBlock;
@property (nonatomic) UIButton *relateView;
@property (nonatomic, copy) dispatch_block_t startBlock;
@property (nonatomic, copy) dispatch_block_t cancelBlock;
@property (nonatomic) UIImageView *image;
@end

@implementation HOTELSliderControl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        _image = [[UIImageView alloc] initWithImage:[UIImage hotel_imageNamed:R_hotel_filter_slidecontrolCopy]];
        [self addSubview:_image];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.image.frame = self.bounds;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint previousLocation = [touch previousLocationInView:self];
    CGPoint currentLocation = [touch locationInView:self];
    CGFloat moveOffset = currentLocation.x - previousLocation.x;
    if (self.moveBlock) {
        self.moveBlock(moveOffset);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
@end



#pragma mark - HOTELSlideView
@interface HOTELSlideView ()

@property (nonatomic) UIView *backView;
@property (nonatomic) UIView *frontView;
@property (nonatomic) HOTELSliderControl *leftControl;
@property (nonatomic) UIButton *leftTip;
@property (nonatomic) HOTELSliderControl *rightControl;
@property (nonatomic) UIButton *rightTip;

@property (nonatomic) NSInteger currentMin;
@property (nonatomic) NSInteger currentMax;
@property (nonatomic, weak) HOTELSliderControl *currentMoveControl; //当前的移动control

@end

@implementation HOTELSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        _currentMin = 0;
        _currentMax = 101;
        
        _backView = [[UIView alloc] init];
        _backView.height = 4.f;
        _backView.layer.cornerRadius = 2.f;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor blueColor];
//        _backView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        _backView.clipsToBounds = NO;
        [self addSubview:_backView];
        
        _frontView = [[UIView alloc] init];
        _frontView.height = 4.f;
        _frontView.backgroundColor = [UIColor redColor];
//        _frontView.backgroundColor = [UIColor colorWithHexString:@"ff6633"];
        [_backView addSubview:_frontView];
        
        _leftControl = [self p_createControl];
        _leftControl.backgroundColor = [UIColor blackColor];
        [self addSubview:_leftControl];
        
        _leftTip = [self p_createTip];
        [self addSubview:_leftTip];
        
        _leftControl.relateView = _leftTip;
        
        _rightControl = [self p_createControl];
        _rightControl.backgroundColor = [UIColor blackColor];
        [self addSubview:_rightControl];
        
        _rightTip = [self p_createTip];
        [self addSubview:_rightTip];
        
        _rightControl.relateView = _rightTip;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //15 + 15
    
    self.backView.width = self.width - 60;
    self.backView.left = (self.width - self.backView.width)/2;
    self.backView.top = (self.height - self.backView.height)/2;
    
    CGFloat percentWidth = self.backView.width / 101;
    
    self.frontView.width = percentWidth * (self.currentMax - self.currentMin);
    self.frontView.left = percentWidth * self.currentMin;
    self.frontView.top = 0;
    
    self.leftControl.top = (self.height - self.leftControl.height)/2;
    self.leftControl.left = 15 + percentWidth * self.currentMin;
    self.leftTip.centerX = self.leftControl.centerX;
    
    self.rightControl.top = (self.height - self.rightControl.height)/2;
    self.rightControl.left = 15 + percentWidth * self.currentMax;
    self.rightTip.centerX = self.rightControl.centerX;
}

- (void)setCurrentPercentMin:(NSInteger)min max:(NSInteger)max {
    self.currentMin = min;
    self.currentMax = max;
    [self setNeedsDisplay];
}

#pragma mark - private

- (HOTELSliderControl *)p_createControl {
    HOTELSliderControl *control = [[HOTELSliderControl alloc] init];
    control.size = CGSizeMake(30, 30);
//    @weakify(self);
//    @weakify(control);
    control.startBlock = ^{
//        @strongify(self);
//        @strongify(control);
        self.currentMoveControl = control;
        self.currentMoveControl.relateView.hidden = NO;
    };
    control.cancelBlock = ^{
//        @strongify(self);
        self.currentMoveControl.relateView.hidden = YES;
        self.currentMoveControl = nil;
    };
    control.moveBlock = ^(CGFloat moveOffset) {
//        @strongify(self);
        CGFloat seperator = self.backView.width / 101;
        CGFloat leftControlX = self.leftControl.centerX;
        CGFloat rightControlX = self.rightControl.centerX;
        
        if (self.currentMoveControl == self.leftControl) {
            if (moveOffset > 0) {
                if (leftControlX + moveOffset >= rightControlX - seperator) {
                    self.currentMoveControl.relateView.hidden = YES;
                    self.currentMoveControl = self.rightControl;
                    self.currentMoveControl.relateView.hidden = NO;
                }
            }
        }
        else {
            if (moveOffset < 0) {
                if (rightControlX + moveOffset <= leftControlX + seperator) {
                    self.currentMoveControl.relateView.hidden = YES;
                    self.currentMoveControl = self.leftControl;
                    self.currentMoveControl.relateView.hidden = NO;
                }
            }
        }
        
        //update frame
        CGRect frame = self.currentMoveControl.frame;
        frame.origin.x += moveOffset;
        frame.origin.x = MAX(15, frame.origin.x);
        frame.origin.x = MIN(self.width-15-self.currentMoveControl.width, frame.origin.x);
        self.currentMoveControl.frame = frame;
        self.currentMoveControl.relateView.centerX = self.currentMoveControl.centerX;
        NSInteger cuValue = (NSInteger)(self.currentMoveControl.centerX-30)/seperator;
        if (cuValue == 101) {
            [self.currentMoveControl.relateView setTitle:@"¥1000+" forState:UIControlStateNormal];
        }
        else {
            [self.currentMoveControl.relateView setTitle:[NSString stringWithFormat:@"¥%@", @(cuValue*10)] forState:UIControlStateNormal];
        }
        
        //update min max
        if (self.currentMoveControl == self.leftControl) {
            leftControlX = frame.origin.x + self.currentMoveControl.width/2;
        }
        else {
            rightControlX = frame.origin.x + self.currentMoveControl.width/2;
        }
        NSInteger min = (NSInteger)(leftControlX - 30)/seperator;
        NSInteger max = (NSInteger)(rightControlX - 30)/seperator;
        self.currentMin = min;
        self.currentMax = max;
        
        self.frontView.width = seperator * (self.currentMax - self.currentMin);
        self.frontView.left = seperator * self.currentMin;
        self.frontView.top = 0;
        
        if (self.slideMoveBlock) {
            self.slideMoveBlock(self.currentMin, self.currentMax);
        }
    };
    return control;
}

- (UIButton *)p_createTip {
    UIButton *tip = [UIButton buttonWithType:UIButtonTypeCustom];
    tip.userInteractionEnabled = NO;
    tip.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [tip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [tip setBackgroundImage:[UIImage hotel_imageNamed:R_hotel_filter_pricetip] forState:UIControlStateNormal];
    tip.size = CGSizeMake(60.f, 35.f);
    tip.top = -35.f;
    tip.hidden = YES;
    tip.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 0);
    return tip;
}

@end

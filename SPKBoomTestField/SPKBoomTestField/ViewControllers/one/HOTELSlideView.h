//
//  HOTELSlideView.h
//  HotelBusiness
//
//  Created by 刘康09 on 2017/10/18.
//

#import <UIKit/UIKit.h>

//分割成101份，min max的取值范围是0-101
typedef void(^HOTELSlideViewMoveBlock)(NSInteger minPercent, NSInteger maxPercent);
@interface HOTELSlideView : UIView

@property (nonatomic, copy) HOTELSlideViewMoveBlock slideMoveBlock;
@property (nonatomic, readonly) NSInteger currentMin;
@property (nonatomic, readonly) NSInteger currentMax;
- (void)setCurrentPercentMin:(NSInteger)min max:(NSInteger)max;

@end

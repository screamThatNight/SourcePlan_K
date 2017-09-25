//
//  SPKNetworkExampleController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#define URL_STRING (@"http://39.108.113.159/lk/lk.php")

#import "SPKNetworkExampleController.h"
#import "DKNetworkManager.h"

#import "UIButton+SPKButton.h"
#import "UIImage+SPKImage.h"
#import "UIColor+SPKColor.h"
#import "UIViewController+SPKController.h"
#import "NSObject+JSON.h"
#import "SPKSlideView.h"
#import "HOTELUserBrowseViewController.h"

@interface SPKNetworkExampleController ()

@property (nonatomic) UITextField *input;

@end

@implementation SPKNetworkExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_createSubviews];
}

#pragma mark - event response

- (void)getAction:(UIButton *)btn {
    //需要客户端对请求做去重。
    // http://39.108.113.159/qyc/test/public/user/list 请求用户信息
    [[DKNetworkManager manager] getRequestWithURLString:@"http://39.108.113.159/qyc/test/public/user/list" success:^(DKNetworkResponse * _Nullable response) {
        [self showToastString:@"请求成功" type:SPKToastTypeSuccess];
    } fail:^(NSError * _Nullable error) {
        [self showToastString:error.localizedDescription type:SPKToastTypeFail];
    }];
}

- (void)postAction:(UIButton *)btn {
    NSLog(@"post");
    // http://39.108.113.159/qyc/test/public/user/add 注册
    NSDictionary *userDic = @{@"name" : @"lk",
                              @"avatar" : @"~ ~",
                              @"mobile" : @"123456",
                              @"sex" : @"男",
                              @"desc" : @"大帅逼"};
    NSDictionary *param = @{@"request" : @{
                                    @"user" : userDic
                                    }};
    
    //用这个始终是无法自己管理线程的吗
    //防止重复请求 所以需要对当前的请求做管理，持有当前的请求，当第二次重新发送请求时，寻找是否在线程中，如果有就不return
    [[DKNetworkManager manager] postRequestWithURLString:@"http://39.108.113.159/qyc/test/public/user/add" param:param success:^(DKNetworkResponse * _Nullable response) {
        [self showToastString:@"请求成功" type:SPKToastTypeSuccess];
    } fail:^(NSError * _Nullable error) {
        [self showToastString:@"请求成功" type:SPKToastTypeSuccess];
    }];
}

- (void)headAction:(UIButton *)btn {
    NSLog(@"head");
    NSLog(@"as");
}

- (void)putAction:(UIButton *)btn {
    NSLog(@"put");
}

- (void)deleteAction:(UIButton *)btn {
    HOTELUserBrowseViewController *pageViewController = [[HOTELUserBrowseViewController alloc] init];
    [self.navigationController pushViewController:pageViewController animated:YES];
}

#pragma mark - private

- (SEL)p_SELForBtnString:(NSString *)str {
    if ([str isEqualToString:@"GET"]) {
        return @selector(getAction:);
    }
    else if ([str isEqualToString:@"POST"]) {
        return @selector(postAction:);
    }
    else if ([str isEqualToString:@"HEAD"]) {
        return @selector(headAction:);
    }
    else if ([str isEqualToString:@"PUT"]) {
        return @selector(putAction:);
    }
    else if ([str isEqualToString:@"DELETE"]) {
        return @selector(deleteAction:);
    }
    return nil;
}

- (void)p_createSubviews {
    // iphoneX以下 statusBar20 navbar44
    // 在iphoneX上 顶部145 中部812
    SPKSlideView *sliderView = [[SPKSlideView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 60) type:SPKSlideViewTypeTwoControls];
    sliderView.backgroundColor = [UIColor orangeColor];
    sliderView.defaultMaxValue = 57;
    sliderView.defaultMinValue = 12;
    sliderView.displayedMaxValue = 101;
    sliderView.slideMoveBlock = ^(CGFloat minValue, CGFloat maxValue) {
        NSLog(@"min : %.f, max : %.f", minValue, maxValue);
    };
    [self.view addSubview:sliderView];
    
    self.input = [[UITextField alloc] initWithFrame:CGRectMake(15, sliderView.bottom + 20, SCREEN_WIDTH - 30, 44)];
    self.input.textColor = [UIColor blackColor];
    self.input.backgroundColor = [[UIColor randomColor] colorWithAlphaComponent:0.2];
    self.input.placeholder = @"   请输入文字";
    self.input.layer.cornerRadius = 5.f;
    self.input.layer.masksToBounds = YES;
    [self.view addSubview:self.input];
    
    CGFloat originY = self.input.bottom + 15;
    NSArray *titleArray = @[@"GET", @"POST", @"HEAD", @"PUT", @"DELETE"];
    for (NSInteger i = 0; i < titleArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithTitle:titleArray[i]
                                             font:[UIFont systemFontOfSize:14.f]
                                 normalTitleColor:[UIColor blackColor]
                                      normalImage:nil
                                    selectedImage:nil
                                 highlightedImage:nil
                                           target:self
                                         selector:[self p_SELForBtnString:titleArray[i]]];
        btn.size = CGSizeMake(SCREEN_WIDTH - 30, 44);
        btn.left = 15;
        btn.top = originY + (btn.height + 15)*i;
        
        UIBezierPath *upath = [UIBezierPath bezierPathWithRect:btn.bounds];
        btn.layer.shadowPath = upath.CGPath;
        btn.layer.shadowOpacity = 0.5;
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, -3);
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageWithColor:[[UIColor randomColor] colorWithAlphaComponent:0.2]] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
}

@end

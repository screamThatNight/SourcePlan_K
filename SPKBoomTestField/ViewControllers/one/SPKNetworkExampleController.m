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
#import "HTLSlideView.h"
#import "HOTELUserBrowseViewController.h"
#import "HOTELSlideView.h"
#import "HOTELUserBrowseViewController.h"

@interface SPKNetworkExampleController ()

@property (nonatomic) UITextField *input;

@end

@implementation SPKNetworkExampleController

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    UIView *testView = [[UIView alloc] init];
//    testView.size = CGSizeMake(100, 100);
//    testView.top = 0;
//    testView.left = 0;
//    testView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:testView];
    
    //是运行期间设置额外的contentInset， 也就是调用setAdditionalSafeAreaInsets 会在某一时刻更新safeAreaInsets，也就是调用更新方法。
//    [self setAdditionalSafeAreaInsets:UIEdgeInsetsMake(30, 10, 10, 10)];
    
    //在iOS11，设置为YES，当滚动视图为最上层视图时，可以确保滚动视图不会被系统视图遮住 但是是在iOS11之后，这个属性被废弃，并且被期望使用滚
//    动视图的新属性contentInsetAdjustmentBehavior
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //隐藏掉navigationBar跟tabBar呢 为什么在首屏 没办法隐藏navigationBar?
    
    //首屏的vc，在viewDidLoad中是获取不到navigationController的
    
    //为什么首屏获取不到navigationController 而可以获取到tabBarcontroller 是因为app的控制器结构问题吧，当即将被推出时才能获取到呢
    
    //得出结论，当navigationBar 或者tabBar被隐藏的时候，view的safeAreaInsets不会包含这两个bar的高度，:{44, 0, 34, 0} 只会包含 statueBar 与 homeIndicator高度。
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.hidden = YES;
    
//    self.navigationController.navigationBar.translucent = NO;
    
    //iOS3 ~ now
    //Default is NO on iOS 6 and earlier. Always YES if barStyle is set to UIBarStyleBlackTranslucent.
    // Default is YES on iOS 7 and later.
//    self.navigationController.navigationBar.translucent = NO;
//
//    //iOS7 ~ now
//    //Default is YES on iOS 7.
//    self.tabBarController.tabBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    NSLog(@"----- log -----");
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"%@", self.view.safeAreaLayoutGuide);
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //小总结
    //1 iOS11之后应该监听viewSafeAreaInsetsDidChange 而iOS11之前应该重写viewDidLayoutSubviews
    //但是为了区分系统版本而一个视图控制器内写两份适配代码不是很好，所以这里应该统一使用viewDidLayoutSubviews 使用viewDidLayoutSubviews可能会多次触发，所以应该
    
    //2 iOS11之前没有safeAreaInset属性，所以应该写一个UIView的分类，用来返回适配过的safeAreaInset
    
    //程序运行期间设置 设置后，会更新并且通知 触发viewSafeAreaInsetsDidChange方法。所以iOS11后实现这个方法很有必要 同样的也会触发viewDidLayoutSubviews 所以iOS11之前的机型 可以通过实现viewDidLayoutSubviews来做适配工作
    
    //所以这个additionalSafeAreaInsets 也可以写一个适配iOS11之前的属性与方法？但是不好 不要这么干。
//    [self setAdditionalSafeAreaInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//
//    HOTELUserBrowseViewController *a = [[HOTELUserBrowseViewController alloc] init];
//    [self.navigationController pushViewController:a animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLog(@"viewDidLayoutSubviews");
    
    //所以 最终在这里适配咯
}

//#pragma mark - event response
//
//- (void)getAction:(UIButton *)btn {
//    //需要客户端对请求做去重。
//    // http://39.108.113.159/qyc/test/public/user/list 请求用户信息
//    [[DKNetworkManager manager] getRequestWithURLString:@"http://39.108.113.159/qyc/test/public/user/list" success:^(DKNetworkResponse * _Nullable response) {
//        [self showToastString:@"请求成功" type:SPKToastTypeSuccess];
//    } fail:^(NSError * _Nullable error) {
//        [self showToastString:error.localizedDescription type:SPKToastTypeFail];
//    }];
//}
//
//- (void)postAction:(UIButton *)btn {
//    NSLog(@"post");
//    // http://39.108.113.159/qyc/test/public/user/add 注册
//    NSDictionary *userDic = @{@"name" : @"lk",
//                              @"avatar" : @"~ ~",
//                              @"mobile" : @"123456",
//                              @"sex" : @"男",
//                              @"desc" : @"大帅逼"};
//    NSDictionary *param = @{@"request" : @{
//                                    @"user" : userDic
//                                    }};
//
//    //用这个始终是无法自己管理线程的吗
//    //防止重复请求 所以需要对当前的请求做管理，持有当前的请求，当第二次重新发送请求时，寻找是否在线程中，如果有就不return
//    [[DKNetworkManager manager] postRequestWithURLString:@"http://39.108.113.159/qyc/test/public/user/add" param:param success:^(DKNetworkResponse * _Nullable response) {
//        [self showToastString:@"请求成功" type:SPKToastTypeSuccess];
//    } fail:^(NSError * _Nullable error) {
//        [self showToastString:@"请求成功" type:SPKToastTypeSuccess];
//    }];
//}
//
//- (void)headAction:(UIButton *)btn {
//    NSLog(@"head");
//    NSLog(@"as");
//
//}
//
//- (void)putAction:(UIButton *)btn {
//    NSLog(@"put");
//}
//
//- (void)deleteAction:(UIButton *)btn {
//    HOTELUserBrowseViewController *pageViewController = [[HOTELUserBrowseViewController alloc] init];
//    [self.navigationController pushViewController:pageViewController animated:YES];
//}
//
//#pragma mark - private
//
//- (SEL)p_SELForBtnString:(NSString *)str {
//    if ([str isEqualToString:@"GET"]) {
//        return @selector(getAction:);
//    }
//    else if ([str isEqualToString:@"POST"]) {
//        return @selector(postAction:);
//    }
//    else if ([str isEqualToString:@"HEAD"]) {
//        return @selector(headAction:);
//    }
//    else if ([str isEqualToString:@"PUT"]) {
//        return @selector(putAction:);
//    }
//    else if ([str isEqualToString:@"DELETE"]) {
//        return @selector(deleteAction:);
//    }
//    return nil;
//}
//
//- (void)p_createSubviews {
//    HTLSlideView *sliderView = [[HTLSlideView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 60) type:HTLSlideViewTypeTwoControls];
//    sliderView.backgroundColor = [UIColor orangeColor];
//    sliderView.defaultMaxValue = 57;
//    sliderView.defaultMinValue = 12;
//    sliderView.displayedMaxValue = 101;
//    sliderView.slideMoveBlock = ^(CGFloat minValue, CGFloat maxValue) {
//    };
//    [self.view addSubview:sliderView];
//
//    self.input = [[UITextField alloc] initWithFrame:CGRectMake(15, sliderView.bottom + 20, SCREEN_WIDTH - 30, 44)];
//    self.input.textColor = [UIColor blackColor];
//    self.input.backgroundColor = [[UIColor randomColor] colorWithAlphaComponent:0.2];
//    self.input.placeholder = @"   请输入文字";
//    self.input.layer.cornerRadius = 5.f;
//    self.input.layer.masksToBounds = YES;
//    [self.view addSubview:self.input];
//
//    CGFloat originY = self.input.bottom + 15;
//    NSArray *titleArray = @[@"GET", @"POST", @"HEAD", @"PUT", @"DELETE"];
//    for (NSInteger i = 0; i < titleArray.count; i ++) {
//        UIButton *btn = [UIButton buttonWithTitle:titleArray[i]
//                                             font:[UIFont systemFontOfSize:14.f]
//                                 normalTitleColor:[UIColor blackColor]
//                                      normalImage:nil
//                                    selectedImage:nil
//                                 highlightedImage:nil
//                                           target:self
//                                         selector:[self p_SELForBtnString:titleArray[i]]];
//        btn.size = CGSizeMake(SCREEN_WIDTH - 30, 44);
//        btn.left = 15;
//        btn.top = originY + (btn.height + 15)*i;
//
//        UIBezierPath *upath = [UIBezierPath bezierPathWithRect:btn.bounds];
//        btn.layer.shadowPath = upath.CGPath;
//        btn.layer.shadowOpacity = 0.5;
//        btn.layer.shadowColor = [UIColor blackColor].CGColor;
//        btn.layer.shadowOffset = CGSizeMake(0, -3);
//        btn.layer.cornerRadius = 5.f;
//        btn.layer.masksToBounds = YES;
//        btn.layer.borderWidth = 1;
//        btn.layer.borderColor = [UIColor redColor].CGColor;
//
//        UIImage *ima = [UIImage imageWithSize:btn.size lineWidth:1/[UIScreen mainScreen].scale borderColor:[UIColor blackColor] cornerRadius:5.f backgroundColor:[UIColor whiteColor]];
//        [btn setBackgroundImage:ima forState:UIControlStateNormal];
//        [self.view addSubview:btn];
//    }
//}

@end

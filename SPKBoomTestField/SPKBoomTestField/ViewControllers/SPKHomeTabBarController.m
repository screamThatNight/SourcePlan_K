//
//  SPKHomeTabBarController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "SPKHomeTabBarController.h"
#import "SPKNetworkExampleController.h"

@interface SPKHomeTabBarController ()

@end

@implementation SPKHomeTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        SPKNetworkExampleController *boomTestField_One = [[SPKNetworkExampleController alloc] init];
        boomTestField_One.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"1" image:nil tag:0];
        
        UIViewController *boomTestField_Two = [[UIViewController alloc] init];
        boomTestField_Two.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"2" image:nil tag:0];
        
        UIViewController *boomTestField_Three = [[UIViewController alloc] init];
        boomTestField_Three.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"3" image:nil tag:0];
        
        UIViewController *boomTestField_Four = [[UIViewController alloc] init];
        boomTestField_Four.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"4" image:nil tag:0];
        
        UIViewController *boomTestField_Five = [[UIViewController alloc] init];
        boomTestField_Five.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"5" image:nil tag:0];
        
        [self setViewControllers:@[boomTestField_One, boomTestField_Two, boomTestField_Three, boomTestField_Four, boomTestField_Five]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end

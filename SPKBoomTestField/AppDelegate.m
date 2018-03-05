//
//  AppDelegate.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/14.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "AppDelegate.h"
#import "SPKHomeViewController.h"
#import "SPKHomeTabBarController.h"

#import "SPKNetworkExampleController.h"

#import "HTLPageChildViewController.h"

#import "SPKGGG.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//版本控制 选择git https://git-scm.com/book/zh/v2
//仓库管理 github gitlab ->点评跟知乎使用的是gitLab

//现在这个情况，要从全局看项目了。

//cocoaPod与github的关联？卧槽...

//1 cocoaPod get
//2 私有仓库化

//项目的持续集成 -> jekins
//项目的远程仓库 -> github https://github.com/screamThatNight
//项目的模块化 -> github 私有仓库
//代码检查 -> OCLint ->

/*
 //工程内部 1.代码规范
 
 路由: -> 处理一切跳转
 netWorkClient -> 负责请求
 babel: -> 摆脱model创建
 
 github私有仓库 -> 模块化 组件化
 
 图片加载速度与图片大小优化 -> webP格式
 
 适用业务的框架
 
 //节省人力方面
 1.自动化打包 -> Jekkins
 2.自动化测试 -> 安卓支持较好的 appium+python iOS由于appium支持较差，最好使用原生方案。
 3
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    SPKHomeTabBarController *homeTabController = [[SPKHomeTabBarController alloc] init];
    SPKHomeViewController *homeController = [[SPKHomeViewController alloc] initWithRootViewController:homeTabController];
    self.window.rootViewController = homeController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

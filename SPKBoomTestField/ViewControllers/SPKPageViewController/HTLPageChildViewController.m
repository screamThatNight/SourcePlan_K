//
//  HTLPageChildViewController.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/20.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "HTLPageChildViewController.h"

@interface HTLPageChildViewController () <UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate>

@property (nonatomic) UITableView *tableView;

@end

@implementation HTLPageChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"child - viewDidLoad");
//    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", self);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@", self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@", self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@", self);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.top = self.view.spk_safeAreaInsets.top;
    self.tableView.height = self.view.height - self.view.spk_safeAreaInsets.top - self.view.spk_safeAreaInsets.bottom;
}

- (void)dealloc {
    NSLog(@"childViewcontroller - dealloc");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *vc = [UIViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

#pragma mark - aaa
//能否编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//    //iOS11上 长拉删除
//    //之前 要点击
//}

//编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"1");
}

#pragma mark - getter or setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.left = 0;
        _tableView.width = self.view.width;
        _tableView.backgroundColor = [UIColor grayColor];
        
        _tableView.separatorInsetReference = UITableViewSeparatorInsetFromAutomaticInsets;
        _tableView.insetsContentViewsToSafeArea = YES;
        
        //iOS11决定tableView的内容与边缘距离的是 adjustedContentInset属性，而不是contetnInset？？？？？
        
//        //adjustedContentInset是只读属性，其依赖于contentInsetAdjustmentBehavior来决定其行为。
//        _tableView.contentInsetAdjustmentBehavior =
//        _tableView.adjustedContentInset =
    }
    return _tableView;
}

@end

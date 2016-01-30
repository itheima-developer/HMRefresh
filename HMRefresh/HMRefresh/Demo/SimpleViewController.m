//
//  SimpleViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/30.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "SimpleViewController.h"
#import "HMRefreshControl.h"

@implementation SimpleViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|"
                               options:0
                               metrics:nil
                               views:@{@"tableview": _tableView}]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[tableview]-0-|"
                               options:0
                               metrics:nil
                               views:@{@"tableview": _tableView}]];
    
    HMRefreshControl *refreshControl = [[HMRefreshControl alloc] init];
    [_tableView addSubview:refreshControl];
    refreshControl.pullupView.backgroundColor = [UIColor redColor];
    
    [refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
}

- (void)loadData:(HMRefreshControl *)refreshControl {
    
    NSLog(@"刷新数据");
}

@end

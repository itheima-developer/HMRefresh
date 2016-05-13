//
//  HMView+TableViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMView+TableViewController.h"
#import <Masonry.h>
#import "CZRefreshControl.h"

static NSString *cellId = @"cellId";

@interface HMView_TableViewController () <UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation HMView_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // Add refresh control
    CZRefreshControl *refreshControl = [[CZRefreshControl alloc] init];
    
    [_tableView addSubview:refreshControl];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}

#pragma mark - 设置界面
- (void)setupUI {
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    tableView.dataSource = self;
    
    _tableView = tableView;
}

@end

//
//  SimpleTableViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/21.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "DemoListViewModel.h"
#import "SimpleCell.h"
#import "HMRefreshControl.h"

@interface SimpleTableViewController ()
@property (nonatomic) DemoListViewModel *listViewModel;
@end

@implementation SimpleTableViewController

- (DemoListViewModel *)listViewModel {
    if (_listViewModel == nil) {
        _listViewModel = [[DemoListViewModel alloc] init];
    }
    return _listViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 添加刷新控件
    HMRefreshControl *refreshControl = [[HMRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self loadData:refreshControl];
}

- (void)loadData:(HMRefreshControl *)refreshControl {
    
    // 开始刷新
    [refreshControl beginRefreshing];
    [self.listViewModel loadData:refreshControl.isPullupRefresh completion:^{
        // 结束刷新
        [refreshControl endRefreshing];
        
        // 刷新表格数据
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listViewModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.content = self.listViewModel.dataList[indexPath.row].description;
    
    return cell;
}

@end

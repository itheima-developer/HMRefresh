//
//  CustomTableViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "CustomTableViewController.h"
#import "DataModel.h"
#import "HMRefreshControl.h"
#import "HMRefreshView.h"

@interface CustomTableViewController ()
@property (nonatomic) DataModel *dataModel;
@end

@implementation CustomTableViewController

- (DataModel *)dataModel {
    if (_dataModel == nil) {
        _dataModel = [[DataModel alloc] init];
    }
    return _dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // 添加刷新控件
    HMRefreshControl *refreshControl = [[HMRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    UINib *nib = [UINib nibWithNibName:@"DemoRefreshView" bundle:nil];
    refreshControl.pulldownView = [nib instantiateWithOwner:nil options:nil].lastObject;
    
    [self loadData];
}

- (void)loadData {
    
    HMRefreshControl *refreshControl = (HMRefreshControl *)self.refreshControl;
    
    // 开始刷新
    [refreshControl beginRefreshing];
    [self.dataModel loadData:refreshControl.isPullupRefresh completion:^{
        // 结束刷新
        [refreshControl endRefreshing];
        
        // 刷新表格数据
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataModel.dataList[indexPath.row]];
    
    return cell;
}

@end

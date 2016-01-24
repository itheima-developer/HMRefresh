//
//  BaiduWMTableViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/25.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "BaiduWMTableViewController.h"
#import "DataModel.h"
#import "HMRefreshControl.h"

@interface BaiduWMTableViewController ()
@property (nonatomic) DataModel *dataModel;
@end

@implementation BaiduWMTableViewController

- (DataModel *)dataModel {
    if (_dataModel == nil) {
        _dataModel = [[DataModel alloc] init];
    }
    return _dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // 刷新控件
    HMRefreshControl *refreshControl = [[HMRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    
    UINib *nib = [UINib nibWithNibName:@"BaiduWMRefreshView" bundle:nil];
    refreshControl.pulldownView = [nib instantiateWithOwner:nil options:nil].lastObject;
    
    self.refreshControl = refreshControl;
    
    [self loadData:refreshControl];
}

- (void)loadData:(HMRefreshControl *)refreshControl {
    
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

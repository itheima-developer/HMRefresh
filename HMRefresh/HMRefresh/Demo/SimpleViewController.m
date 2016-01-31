//
//  SimpleViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/30.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "SimpleViewController.h"
#import "DataModel.h"
#import "HMRefreshControl.h"

@interface SimpleViewController() <UITableViewDataSource>
@property (nonatomic) DataModel *dataModel;
@end

@implementation SimpleViewController {
    UITableView *_tableView;
}

- (DataModel *)dataModel {
    if (_dataModel == nil) {
        _dataModel = [[DataModel alloc] init];
    }
    return _dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.dataSource = self;
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
    
    [refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    [self loadData:refreshControl];
}

- (void)loadData:(HMRefreshControl *)refreshControl {
    
    NSLog(@"刷新数据");
    [refreshControl beginRefreshing];
    [self.dataModel loadData:refreshControl.isPullupRefresh completion:^{
        // 结束刷新
        [refreshControl endRefreshing];
        
        // 刷新表格数据
        [_tableView reloadData];
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

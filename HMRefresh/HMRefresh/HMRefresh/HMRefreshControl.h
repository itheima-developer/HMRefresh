//
//  HMRefreshControl.h
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMRefreshView.h"

/**
 刷新控件 - HMRefreshControl
 
 示例代码：
 
 1. 在 UITableViewController 中实例化刷新控件
 
 @code
 self.refreshControl = [[HMRefreshControl alloc] init];
 [self.refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
 @endcode
 
 2. 在 loadData: 方法中设置刷新控件状态
 
 @code
 // 开始刷新
 [refreshControl beginRefreshing];
 
 // 发起网络请求，异步加载数据
 [self.dataModal loadData:refreshControl.isPullupRefresh completion:^{
     // 结束刷新
     [refreshControl endRefreshing];
     
     // 刷新数据
     [self.tableView reloadData];
 }];
 @endcode
 
 @remark 注意 `网络请求` 方法中要根据 `isPullupRefresh` 参数决定如何加载数据，具体代码可以参照 `DataModel` 中的示例代码
 */
@interface HMRefreshControl : UIControl
/// 下拉刷新视图
@property (nonatomic) UIView<HMRefreshViewDelegate> *pulldownView;
/// 上拉刷新视图
@property (nonatomic) UIView<HMRefreshViewDelegate> *pullupView;
/// 刷新类型(无/下拉/上拉)
@property (nonatomic, readonly) HMRefreshType refreshType;
/// 是否上拉刷新
@property (nonatomic, readonly) BOOL isPullupRefresh;
/// 如果没有数据，上拉刷新重试次数，默认为 3
@property (nonatomic) NSInteger pullupRetryTimes;

/// 开始刷新
- (void)beginRefreshing;
/// 结束刷新
- (void)endRefreshing;

/// 默认状态提示文字，默认：@"下拉刷新数据"
@property (nonatomic) NSString *normalString;
/// 将要刷新提示文字，默认：@"放开开始刷新"
@property (nonatomic) NSString *pullingString;
/// 正在刷新提示文字，默认：@"正在刷新数据..."
@property (nonatomic) NSString *refreshingString;
/// 没有数据提示文字，默认：@"没有新数据"
@property (nonatomic) NSString *noDataString;
/// 上次刷新提示文字，默认：@"上次刷新 "
@property (nonatomic) NSString *lastRefreshString;
/// 不再上拉刷新提示文字，默认：@"没有新数据，不再刷新"
@property (nonatomic) NSString *donotPullupString;
@end

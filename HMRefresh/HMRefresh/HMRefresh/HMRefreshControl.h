//
//  HMRefreshControl.h
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMRefreshView;

/// 刷新控件
@interface HMRefreshControl : UIRefreshControl
/// 下拉刷新视图
@property (nonatomic) HMRefreshView *pulldownView;
/// 上拉刷新视图
@property (nonatomic) HMRefreshView *pullupView;
/// 是否上拉刷新
@property (nonatomic, readonly) BOOL isPullupRefresh;
/// 如果没有数据，上拉刷新重试次数，默认为 3
@property (nonatomic) NSInteger pullupRetryTimes;

/// 默认状态提示文字 - @"下拉刷新数据"
@property (nonatomic) NSString *normalString;
/// 将要刷新提示文字 - @"放开开始刷新"
@property (nonatomic) NSString *pullingString;
/// 正在刷新提示文字 - @"正在刷新数据..."
@property (nonatomic) NSString *refreshingString;
/// 没有数据提示文字 - @"没有新数据"
@property (nonatomic) NSString *noDataString;
/// 上次刷新提示文字 - @"上次刷新 "
@property (nonatomic) NSString *lastRefreshString;
/// 不再上拉刷新提示文字 - @"没有新数据，不再刷新"
@property (nonatomic) NSString *donotPullupString;
@end

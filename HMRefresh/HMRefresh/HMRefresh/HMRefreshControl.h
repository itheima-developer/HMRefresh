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
@end

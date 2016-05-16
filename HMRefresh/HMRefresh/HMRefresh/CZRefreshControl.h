//
//  CZRefreshControl.h
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZRefreshView.h"

@interface CZRefreshControl : UIControl

/// 指定构造函数
///
/// - 使用 `pulldownView` 和 `pullupView` 实例化 CZRefreshControl
/// - 使用 `addSubview` 将此控件添加到 `UITableView` 或者 `UICollectionView`
/// - 刷新控件的大小自动管理
/// - 用户 `下拉` 或者 `上拉` 刷新时，会触发 `UIControlEventValueChanged` 事件
/// - 通过 `isPullupRefresh` 可以在监听方法中判断刷新类型
/// - 如果没有指定 `pulldownView` 则不支持下拉刷新
/// - 如果没有指定 `pullupView` 则不支持上拉刷新
- (nonnull instancetype)initWithPulldownView:(nullable UIView<CZRefreshViewDelegate> *)pulldownView pullupView:(nullable UIView<CZRefreshViewDelegate> *)pullupView;

/// 是否上拉刷新
@property (nonatomic, readonly) BOOL isPullupRefresh;

/// 下拉刷新视图
@property (nullable, nonatomic, readonly) UIView<CZRefreshViewDelegate> *pulldownView;
/// 上拉刷新视图
@property (nullable, nonatomic, readonly) UIView<CZRefreshViewDelegate> *pullupView;

///// 刷新状态
//@property (nonatomic, assign) CZRefreshState refreshState;

@end

//
//  CZRefreshView.h
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 刷新状态枚举
typedef NS_ENUM(NSInteger, CZRefreshState) {
    CZRefreshStateNormal,           // 默认状态或者松开手就回到默认状态
    CZRefreshStateWillRefresh,      // 将要刷新 - 松开手就进入刷新的状态
    CZRefreshStateDidRefreshing,    // 正在刷新
};

/// 刷新视图协议
@protocol CZRefreshViewDelegate <NSObject>

@optional

/// 下拉刷新视图拖拽
///
/// @param offset 纵向偏移量
///
/// 提示：可以在此代理方法中，实现下拉过程中的动画效果
- (void)pulldownViewBeginDraggingWithOffset:(CGFloat)offset;

/// 下拉刷新视图将要刷新
///
/// 提示：可以在此代理方法中，实现将要刷新的动画效果，例如转动指示器
- (void)pulldownViewWillRefresh;

@optional

@end

/// 默认刷新视图
@interface CZRefreshView : UIView <CZRefreshViewDelegate>

@end

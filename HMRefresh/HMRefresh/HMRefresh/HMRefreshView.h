//
//  HMRefreshView.h
//  HMRefresh
//
//  Created by 刘凡 on 16/1/21.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 刷新状态枚举
/// - HMRefreshStateNormal:       默认状态或者松开手就回到默认状态
/// - HMRefreshStatePulling:      将要刷新 - 松开手就进入刷新的状态
/// - HMRefreshStateRefreshing:   正在刷新
typedef enum : NSUInteger {
    HMRefreshStateNormal,
    HMRefreshStatePulling,
    HMRefreshStateRefreshing,
} HMRefreshState;

/// 刷新类型枚举
/// - HMRefreshTypePulldown:      下拉刷新
/// - HMRefreshTypePullup:        上拉刷新
typedef enum : NSUInteger {
    HMRefreshTypePulldown,
    HMRefreshTypePullup
} HMRefreshType;

/**
 刷新视图协议 - 自定义刷新视图需要遵守此协议
 
 示例代码：
 
 1. 遵守协议
 
 @code
 @interface DemoRefreshView : UIView <HMRefreshViewDelegate>
 @endcode
 
 2. 从 Storyboard 或者 XIB 将控件连线到私有扩展中
 
 @code
 /// 刷新指示器
 @property (nonatomic, weak) IBOutlet UIActivityIndicatorView *refreshIndicator;
 /// 下拉提示图像
 @property (nonatomic, weak) IBOutlet UIImageView *pulldownIcon;
 /// 提示标签
 @property (nonatomic, weak) IBOutlet UILabel *tipLabel;
 /// 刷新时间标签
 @property (nonatomic, weak) IBOutlet UILabel *timeLabel;
 @endcode
 */
@protocol HMRefreshViewDelegate <NSObject>

/// 下拉提示图像
@property (nonatomic, weak, readonly) UIImageView *pulldownIcon;
/// 刷新指示器
@property (nonatomic, weak, readonly) UIActivityIndicatorView *refreshIndicator;
/// 提示标签
@property (nonatomic, weak, readonly) UILabel *tipLabel;
/// 刷新时间标签
@property (nonatomic, weak, readonly) UILabel *timeLabel;

@optional
/// 下拉刷新视图正在被拖拽
///
/// @param refreshView 下拉刷新视图
/// @param offsetY     Y 方向偏移量，用于自定义动画
/// @param state       刷新视图状态(HMRefreshStateNormal/HMRefreshStatePulling)
- (void)refreshView:(UIView <HMRefreshViewDelegate> *)refreshView beginDraggingOffsetY:(CGFloat)offsetY state:(HMRefreshState)state;

/// 刷新视图正在刷新
///
/// @param refreshView 刷新视图
/// @param refreshType 刷新类型(上拉/下拉)
- (void)refreshViewDidRefreshing:(UIView <HMRefreshViewDelegate> *)refreshView refreshType:(HMRefreshType)refreshType;

/// 刷新视图完成刷新
///
/// @param refreshView 刷新视图
- (void)refreshViewDidEndRefreshed:(UIView<HMRefreshViewDelegate> *)refreshView;

@end

@interface HMRefreshView : UIView <HMRefreshViewDelegate>

@end


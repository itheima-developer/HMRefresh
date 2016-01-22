//
//  HMRefreshView.h
//  HMRefresh
//
//  Created by 刘凡 on 16/1/21.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 刷新视图协议 - 自定义刷新视图需要遵守此协议
@protocol HMRefreshViewDelegate <NSObject>

/// 下拉提示图像
@property (nonatomic, readonly) UIImageView *pulldownIcon;
/// 刷新指示器
@property (nonatomic, readonly) UIActivityIndicatorView *refreshIndicator;
/// 提示标签
@property (nonatomic, readonly) UILabel *tipLabel;
/// 刷新时间标签
@property (nonatomic, readonly) UILabel *timeLabel;

/// 开始动画
- (void)startAnimating;
/// 停止动画
- (void)stopAnimating;
/// 是否正在动画
- (BOOL)isAnimating;

@end

@interface HMRefreshView : UIView <HMRefreshViewDelegate>

@end


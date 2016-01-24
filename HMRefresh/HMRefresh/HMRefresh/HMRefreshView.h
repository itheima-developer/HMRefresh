//
//  HMRefreshView.h
//  HMRefresh
//
//  Created by 刘凡 on 16/1/21.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end

@interface HMRefreshView : UIView <HMRefreshViewDelegate>

@end


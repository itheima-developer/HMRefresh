//
//  DemoRefreshView.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "DemoRefreshView.h"

@interface DemoRefreshView()
/// 刷新指示器
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *refreshIndicator;
/// 下拉提示图像
@property (nonatomic, weak) IBOutlet UIImageView *pulldownIcon;
/// 提示标签
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
/// 刷新时间标签
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@end

@implementation DemoRefreshView

@end

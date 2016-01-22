//
//  HMRefreshControl.h
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 刷新控件
@interface HMRefreshControl : UIRefreshControl
/// 是否上拉刷新
@property (nonatomic, readonly) BOOL isPullupRefresh;
@end

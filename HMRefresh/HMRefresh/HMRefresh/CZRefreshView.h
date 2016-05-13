//
//  CZRefreshView.h
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 刷新视图协议
@protocol CZRefreshViewDelegate <NSObject>

@optional

@end

/// 默认刷新视图
@interface CZRefreshView : UIView <CZRefreshViewDelegate>

@end

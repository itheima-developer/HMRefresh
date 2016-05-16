//
//  CZRefreshView.m
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "CZRefreshView.h"

@implementation CZRefreshView

- (void)pulldownViewBeginDraggingWithOffset:(CGFloat)offset state:(CZRefreshState)state {
    
    if (state == CZRefreshStateNormal) {
        NSLog(@"下拉开始刷新 %f", offset);
    } else if (state == CZRefreshStateWillRefresh) {
        NSLog(@"放开开始刷新 %f", offset);
    }
}

@end

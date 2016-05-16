//
//  CZRefreshView.m
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "CZRefreshView.h"

@implementation CZRefreshView

- (void)pulldownViewBeginDraggingWithOffset:(CGFloat)offset {
    NSLog(@"下拉 %f", offset);
}

- (void)pulldownViewWillRefresh {
    NSLog(@"将要开始刷新");
}

@end

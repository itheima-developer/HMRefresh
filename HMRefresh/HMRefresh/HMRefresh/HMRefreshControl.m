//
//  HMRefreshControl.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMRefreshControl.h"

@implementation HMRefreshControl {
    __weak id __target;
    SEL __action;
    
    BOOL _isRefreshing;
}

#pragma mark - 构造函数
- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
        });
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - 父类方法及属性
- (BOOL)isRefreshing {
    return _isRefreshing || _isPullupRefresh;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    __target = target;
    __action = action;
}

- (void)beginRefreshing {
    NSLog(@"开始刷新");
    [super beginRefreshing];
}

- (void)endRefreshing {
    NSLog(@"结束刷新");
    [super endRefreshing];
    
    _isRefreshing = NO;
}

#pragma mark - KVO 相关方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 发送刷新事件
    if (self.frame.origin.y < -80 && _isRefreshing == NO) {
        _isRefreshing = YES;
        [self sendAction:__action to:__target forEvent:[[UIEvent alloc] init]];
    }
}

@end

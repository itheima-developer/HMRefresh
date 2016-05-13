//
//  CZRefreshControl.m
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "CZRefreshControl.h"

@implementation CZRefreshControl {
    __weak UIScrollView *_scrollView;
}

- (instancetype)initWithPulldownView:(UIView<CZRefreshViewDelegate> *)pulldownView pullupView:(UIView<CZRefreshViewDelegate> *)pullupView {
    self = [super init];
    if (self) {
        _pulldownView = pulldownView;
        _pullupView = pullupView;
        
        [self prepareRefreshViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self prepareRefreshViews];
    }
    return self;
}

#pragma mark - Life cycle
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        return;
    }
    NSAssert([newSuperview isKindOfClass:[UITableView class]] ||
             [newSuperview isKindOfClass:[UICollectionView class]], @"刷新控件只能用于 UITableView 或者 UICollectionView 的子类");
    
    _scrollView = (UIScrollView *)newSuperview;
    _scrollView.alwaysBounceVertical = YES;
    
    // KVO
    [newSuperview addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [newSuperview addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}

- (void)removeFromSuperview {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    
    [super removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _pulldownView.frame = self.bounds;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"%@", _scrollView);
}

#pragma mark - Prepare Refresh Views
- (void)prepareRefreshViews {
    self.backgroundColor = [UIColor redColor];
    
    // 检查刷新视图，同时没有指定刷新视图，则使用默认视图
    if (_pulldownView == nil && _pullupView == nil) {
        _pulldownView = [[CZRefreshView alloc] init];
        _pullupView = [[CZRefreshView alloc] init];
    }
}

@end

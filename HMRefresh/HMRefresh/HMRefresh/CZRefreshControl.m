//
//  CZRefreshControl.m
//  HMRefresh
//
//  Created by 刘凡 on 16/5/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "CZRefreshControl.h"

/// 刷新控件偏移量
#define HMRefreshControlOffset      60
/// 上拉刷新视图高度
#define HMRefreshPullupViewHeight   44

@implementation CZRefreshControl {
    __weak UIScrollView *_scrollView;
    
    CZRefreshState      _refreshState;
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
    
    // 添加上拉视图
    if (_pullupView != nil) {
        [newSuperview addSubview:_pullupView];
    }
    
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
    
    if ([keyPath isEqual: @"contentSize"]) {
        [self changePullupViewSize];
    }
    
    [self changePulldownViewSize];
    
    CGFloat height = self.bounds.size.height;
    if (height <= 0 || _pulldownView == nil) {
        return;
    }
    
    // 下拉刷新逻辑
    if (_scrollView.isDragging) {
        if (_refreshState == CZRefreshStateNormal && height > HMRefreshControlOffset) {
            _refreshState = CZRefreshStateWillRefresh;
            
            if ([_pulldownView respondsToSelector:@selector(pulldownViewWillRefresh)]) {
                [_pulldownView pulldownViewWillRefresh];
            }
        } else if (_refreshState == CZRefreshStateWillRefresh && height < HMRefreshControlOffset) {
            _refreshState = CZRefreshStateNormal;
        }
        
        if (_refreshState == CZRefreshStateNormal &&
            [_pulldownView respondsToSelector:@selector(pulldownViewBeginDraggingWithOffset:)]) {
            
            [_pulldownView pulldownViewBeginDraggingWithOffset:height];
        }
    } else {
        if (_refreshState == CZRefreshStateWillRefresh) {
            _refreshState = CZRefreshStateDidRefreshing;
            NSLog(@"开始刷新了");
        }
    }
}

/// 修改上拉视图大小
- (void)changePullupViewSize {
    
    if (_scrollView == nil || _pullupView == nil) {
        return;
    }
    
    CGSize size = _scrollView.contentSize;
    
    _pullupView.frame = CGRectMake(0, size.height, size.width, HMRefreshPullupViewHeight);
    
    if (!CGRectIsEmpty(_scrollView.frame) && _pullupView.tag == 0) {
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.bottom += HMRefreshPullupViewHeight;
        
        [_scrollView removeObserver:self forKeyPath:@"contentSize"];
        _scrollView.contentInset = inset;
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
        
        _pullupView.tag = 1;
    }
}

/// 修改下拉视图大小
- (void)changePulldownViewSize {
    
    if (_scrollView == nil || _pulldownView == nil) {
        return;
    }
    
    CGFloat height = -(_scrollView.contentOffset.y + _scrollView.contentInset.top);
    height = height > 0 ? height : 0;
    
    CGFloat x = 0;
    CGFloat y = -height;
    CGFloat width = _scrollView.bounds.size.width;
    
    self.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Prepare Refresh Views
- (void)prepareRefreshViews {
    self.backgroundColor = [UIColor redColor];
    
    // 检查刷新视图，同时没有指定刷新视图，则使用默认视图
    if (_pulldownView == nil && _pullupView == nil) {
        _pulldownView = [[CZRefreshView alloc] init];
        _pulldownView.backgroundColor = [UIColor blueColor];
        
        _pullupView = [[CZRefreshView alloc] init];
        _pullupView.backgroundColor = [UIColor orangeColor];
    }
}

@end

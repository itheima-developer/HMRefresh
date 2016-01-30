//
//  HMRefreshControl.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMRefreshControl.h"
#import "HMRefreshView.h"
#import <objc/message.h>

/// 刷新控件偏移量
#define HMRefreshControlOffset -60
/// 末次刷新日期 Key
NSString *const HMRefreshControlLastRefreshDateKey = @"HMRefreshControlLastRefreshDateKey";

@interface HMRefreshControl()
@property (nonatomic) HMRefreshState refreshState;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation HMRefreshControl {
    NSDateFormatter *_dateFormatter;
    NSCalendar *_calendar;
    
    CGFloat _preOffsetY;
    NSIndexPath *_prePullupIndexPath;
    NSInteger _retryTimes;
}
@synthesize pulldownView = _pulldownView;
@synthesize pullupView = _pullupView;

#pragma mark - 构造函数
- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 60)];
    if (self) {
        // 没有新数据默认重试次数
        _pullupRetryTimes = 3;
        
        // 设置日期格式化
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _calendar = [NSCalendar currentCalendar];
        
        // 设置背景颜色
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // KVO
    _scrollView = (UIScrollView *)newSuperview;
    _scrollView.alwaysBounceVertical = YES;
    
    [newSuperview addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [newSuperview addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}

- (void)removeFromSuperview {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    [super removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = self.bounds.size.width * 0.5;
    CGFloat y = (self.bounds.size.height - self.pulldownView.bounds.size.height * 0.5);
    self.pulldownView.center = CGPointMake(x, y);
}

- (NSString *)refreshDateString {
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:HMRefreshControlLastRefreshDateKey];
    
    if (date == nil) {
        return [self.lastRefreshString stringByAppendingString:@"无"];
    }
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *todayComponents = [_calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [_calendar components:unitFlags fromDate:date];
    
    NSString *fmt = @" HH:mm";
    if (todayComponents.year == dateComponents.year) {
        if (todayComponents.month == dateComponents.month && todayComponents.day == dateComponents.day) {
            fmt = [@"今天 " stringByAppendingString:fmt];
        } else {
            fmt = [@"MM-dd " stringByAppendingString:fmt];
        }
    } else {
        fmt = [@"yyyy-MM-dd " stringByAppendingString:fmt];
    }
    _dateFormatter.dateFormat = fmt;
    
    return [self.lastRefreshString stringByAppendingString:[_dateFormatter stringFromDate:date]];
}

- (void)showRefreshDate:(NSDate *)date {
    if (date != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:HMRefreshControlLastRefreshDateKey];
    }
    
    NSString *dateStr = [self refreshDateString];
    
    self.pulldownView.timeLabel.text = dateStr;
    self.pullupView.timeLabel.text = dateStr;
}

#pragma mark - 刷新方法及属性
- (BOOL)isPullupRefresh {
    return _refreshType == HMRefreshTypePullup;
}

- (void)beginRefreshing {
    [self showRefreshDate:[NSDate date]];
    
    if (self.refreshType == HMRefreshTypePullup) {
        self.pullupView.tipLabel.text = self.refreshingString;
        [self startAnimating:self.pullupView];
        
        if ([self.pullupView respondsToSelector:@selector(refreshViewDidRefreshing:refreshType:)]) {
            [self.pullupView refreshViewDidRefreshing:self.pullupView refreshType:_refreshType];
        }
    } else {
        _refreshType = HMRefreshTypePulldown;
        if (self.frame.size.height <= 0) {
            self.frame = CGRectMake(0, HMRefreshControlOffset, self.bounds.size.width, -HMRefreshControlOffset);
        }
        
        [self evaluateScrollViewInset:-HMRefreshControlOffset completion:^{
            self.pulldownView.tipLabel.text = self.refreshingString;
            self.pulldownView.pulldownIcon.hidden = YES;
            [self startAnimating:self.pulldownView];
            
            if ([self.pulldownView respondsToSelector:@selector(refreshViewDidRefreshing:refreshType:)]) {
                [self.pulldownView refreshViewDidRefreshing:self.pullupView refreshType:_refreshType];
            }
            _refreshState = HMRefreshStateRefreshing;
        }];
    }
}

- (void)endRefreshing {
    // 上拉刷新结束
    if (_refreshType == HMRefreshTypePullup) {
        [self stopAnimating:self.pullupView];
        self.pullupView.tipLabel.text = self.normalPullupString;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[self lastIndexPath] compare:_prePullupIndexPath] == NSOrderedSame) {
                _retryTimes++;
                self.pullupView.tipLabel.text = self.noDataString;
            } else {
                _retryTimes = 0;
            }
            
            _refreshType = HMRefreshTypeNone;
            
            if ([self.pullupView respondsToSelector:@selector(refreshViewDidEndRefreshed:)]) {
                [self.pullupView refreshViewDidEndRefreshed:self.pullupView];
            }
        });
        return;
    }
    
    // 下拉刷新结束
    _refreshType = HMRefreshTypeNone;
    [self evaluateScrollViewInset:HMRefreshControlOffset completion:^{
        // 设置下拉视图状态
        [self.pulldownView.refreshIndicator stopAnimating];
        self.pulldownView.pulldownIcon.hidden = NO;
        
        self.pulldownView.pulldownIcon.transform = CGAffineTransformIdentity;
        self.pulldownView.tipLabel.text = self.normalString;
        
        _refreshState = HMRefreshStateNormal;
        
        // 通知视图刷新完成
        if ([self.pulldownView respondsToSelector:@selector(refreshViewDidEndRefreshed:)]) {
            [self.pulldownView refreshViewDidEndRefreshed:self.pulldownView];
        }
    }];
}

#pragma mark - KVO 相关方法
- (void)evaluateScrollViewInset:(CGFloat)offset completion:(void (^)())completion {
    // 恢复顶部滑动距离
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.top += offset;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = inset;
    } completion:^(BOOL finished) {
        if (completion != nil) {
            completion();
        }
    }];
}

- (void)evaluateFrame {
    CGFloat offsetY = self.scrollView.contentOffset.y + self.scrollView.contentInset.top;
    CGFloat height = offsetY < 0 ? -offsetY : 0;
    CGRect rect = CGRectMake(0, offsetY, self.scrollView.bounds.size.width, height);
    
    self.frame = rect;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqual: @"contentSize"]) {
        [self setPullupViewLocation];
        
        return;
    }
    
    UIScrollView *scrollView = self.scrollView;
    if (scrollView == nil) {
        return;
    }
    
    // 如果正在刷新，直接返回
    if (self.refreshType != HMRefreshTypeNone) {
        return;
    }
    [self evaluateFrame];
    
    // 上拉刷新逻辑
    if (scrollView.contentOffset.y + scrollView.contentInset.top > 0) {
        if (_preOffsetY < scrollView.contentOffset.y) {
            [self checkPullup];
        }
        _preOffsetY = scrollView.contentOffset.y;
        return;
    }
    
    // 下拉刷新逻辑
    if (scrollView.isDragging) {
        if (self.refreshState == HMRefreshStateNormal && self.frame.origin.y < HMRefreshControlOffset) {
            self.refreshState = HMRefreshStatePulling;
        } else if (self.refreshState == HMRefreshStatePulling && self.frame.origin.y > HMRefreshControlOffset) {
            self.refreshState = HMRefreshStateNormal;
        }
        if ([self.pulldownView respondsToSelector:@selector(refreshView:beginDraggingOffsetY:state:)]) {
            [self.pulldownView refreshView:self.pulldownView beginDraggingOffsetY:self.frame.origin.y state:self.refreshState];
        }
    } else {
        if (self.refreshState == HMRefreshStatePulling) {
            self.refreshState = HMRefreshStateRefreshing;
        }
    }
}

/// 设置上拉视图位置
- (void)setPullupViewLocation {
    UIScrollView *scrollView = self.scrollView;
    if (scrollView == nil) {
        return;
    }
    
    CGRect rect = self.pullupView.bounds;
    if (scrollView.contentSize.height < scrollView.bounds.size.height + scrollView.contentOffset.y - self.frame.origin.y) {
        CGSize size = scrollView.bounds.size;
        
        size.height += scrollView.contentOffset.y - self.frame.origin.y;
        scrollView.contentSize = size;
    }
    
    rect.origin.y = scrollView.contentSize.height;
    rect.origin.x = (scrollView.bounds.size.width - rect.size.width) * 0.5;
    
    self.pullupView.frame = rect;
}

/// 检查上拉刷新
- (void)checkPullup {
    
    if (!([self.scrollView isKindOfClass:[UITableView class]] || [self.scrollView isKindOfClass:[UICollectionView class]])) {
        return;
    }
    
    if (_retryTimes >= self.pullupRetryTimes) {
        self.pullupView.tipLabel.text = self.donotPullupString;
        return;
    }
    
    UIScrollView *parentView = self.scrollView;
    
    _prePullupIndexPath = [self lastIndexPath];
    if (_prePullupIndexPath == nil) {
        self.pullupView.tipLabel.text = self.noDataString;
        return;
    }
    
    SEL numberSel;
    if ([parentView isKindOfClass:[UITableView class]]) {
        numberSel = @selector(cellForRowAtIndexPath:);
    } else {
        numberSel = @selector(cellForItemAtIndexPath:);
    }
    
    id cell = ((id (*)(id, SEL, NSIndexPath *))objc_msgSend)(parentView, numberSel, _prePullupIndexPath);
    
    if (cell == nil) {
        return;
    }
    
    if (![self isAnimating:self.pullupView]) {
        _refreshType = HMRefreshTypePullup;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (NSIndexPath *)lastIndexPath {
    
    if (!([self.scrollView isKindOfClass:[UITableView class]] || [self.scrollView isKindOfClass:[UICollectionView class]])) {
        return nil;
    }
    
    UIScrollView *parentView = self.scrollView;
    
    NSInteger section = ((NSInteger (*)(id, SEL))objc_msgSend)(parentView, @selector(numberOfSections));
    if (section <= 0) {
        return nil;
    }
    
    NSInteger row;
    SEL numberSel;
    if ([parentView isKindOfClass:[UITableView class]]) {
        numberSel = @selector(numberOfRowsInSection:);
    } else {
        numberSel = @selector(numberOfItemsInSection:);
    }
    do {
        row = ((NSInteger (*)(id, SEL, NSInteger))objc_msgSend)(parentView, numberSel, --section);
    } while (row <= 0 && section > 0);
    
    if (row <= 0) {
        return nil;
    }
    
    return [NSIndexPath indexPathForRow:row - 1 inSection:section];
}

/// 设置下拉刷新状态
- (void)setRefreshState:(HMRefreshState)refreshState {
    _refreshState = refreshState;
    
    switch (refreshState) {
        case HMRefreshStateNormal: {
            self.pulldownView.tipLabel.text = self.normalString;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.pulldownView.pulldownIcon.transform = CGAffineTransformIdentity;
            }];
        }
            break;
        case HMRefreshStatePulling: {
            self.pulldownView.tipLabel.text = self.pullingString;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.pulldownView.pulldownIcon.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
            break;
        case HMRefreshStateRefreshing:
            // 判断是否添加了监听方法
            if (self.allTargets.count == 0) {
                self.refreshState = HMRefreshStateNormal;
            } else {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            
            break;
    }
}

#pragma mark - 刷新视图方法
- (void)startAnimating:(UIView <HMRefreshViewDelegate> *)refreshView {
    [refreshView.refreshIndicator startAnimating];
}

- (void)stopAnimating:(UIView <HMRefreshViewDelegate> *)refreshView {
    [refreshView.refreshIndicator stopAnimating];
}

- (BOOL)isAnimating:(UIView <HMRefreshViewDelegate> *)refreshView {
    return refreshView.refreshIndicator.isAnimating;
}

#pragma mark - 上拉/下拉视图
- (UIView<HMRefreshViewDelegate> *)pulldownView {
    if (_pulldownView == nil) {
        self.pulldownView = [[HMRefreshView alloc] init];
    }
    return _pulldownView;
}

- (void)setPulldownView:(UIView<HMRefreshViewDelegate> *)pulldownView {
    [_pulldownView removeFromSuperview];
    
    _pulldownView = pulldownView;
    
    _pulldownView.tipLabel.text = self.normalString;
    _pulldownView.pulldownIcon.hidden = NO;
    _pulldownView.refreshIndicator.hidesWhenStopped = YES;
    
    [self addSubview:_pulldownView];
}

- (UIView<HMRefreshViewDelegate> *)pullupView {
    if (_pullupView == nil) {
        self.pullupView = [[HMRefreshView alloc] init];
    }
    return _pullupView;
}

- (void)setPullupView:(UIView<HMRefreshViewDelegate> *)pullupView {
    
    if (self.scrollView == nil) {
        return;
    }
    
    [_pullupView removeFromSuperview];
    
    _pullupView = pullupView;
    [self.scrollView addSubview:_pullupView];
    
    // 调整底部间距
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.bottom += _pullupView.bounds.size.height;
    self.scrollView.contentInset = inset;
}

#pragma mark - 提示文字
- (NSString *)normalString {
    if (_normalString == nil) {
        _normalString = @"下拉刷新数据";
    }
    return _normalString;
}

- (NSString *)normalPullupString {
    if (_normalPullupString == nil) {
        _normalPullupString = @"上拉刷新数据";
    }
    return _normalPullupString;
}

- (NSString *)pullingString {
    if (_pullingString == nil) {
        _pullingString = @"放开开始刷新";
    }
    return _pullingString;
}

- (NSString *)refreshingString {
    if (_refreshingString == nil) {
        _refreshingString = @"正在刷新数据...";
    }
    return _refreshingString;
}

- (NSString *)noDataString {
    if (_noDataString == nil) {
        _noDataString = @"没有新数据";
    }
    return _noDataString;
}

- (NSString *)lastRefreshString {
    if (_lastRefreshString == nil) {
        _lastRefreshString = @"上次刷新 ";
    }
    return _lastRefreshString;
}

- (NSString *)donotPullupString {
    if (_donotPullupString == nil) {
        _donotPullupString = @"没有新数据，不再刷新";
    }
    return _donotPullupString;
}

@end

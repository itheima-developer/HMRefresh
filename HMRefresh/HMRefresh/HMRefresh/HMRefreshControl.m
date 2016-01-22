//
//  HMRefreshControl.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMRefreshControl.h"
#import "HMRefreshView.h"

/// 刷新控件偏移量
#define HMRefreshControlOffset -60

/// 刷新状态枚举
/// - HMRefreshStateNormal:       默认状态或者松开手就回到默认状态
/// - HMRefreshStatePulling:      将要刷新 - 松开手就进入刷新的状态
/// - HMRefreshStateRefreshing:   正在刷新
typedef enum : NSUInteger {
    HMRefreshStateNormal,
    HMRefreshStatePulling,
    HMRefreshStateRefreshing,
} HMRefreshState;

@interface HMRefreshControl()
@property (nonatomic) HMRefreshState refreshState;
@end

@implementation HMRefreshControl {
    __weak id __target;
    SEL __action;
    
    BOOL _isRefreshing;
    
    UIView *_contentView;
}

#pragma mark - 构造函数
- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self prepareUI];
            
            [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
        });
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
    NSLog(@"%s", __FUNCTION__);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = _contentView.bounds.size.width * 0.5;
    CGFloat y = (self.bounds.size.height - self.pulldownView.bounds.size.height * 0.5);
    self.pulldownView.center = CGPointMake(x, y);
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
    
    if (!self.isPullupRefresh) {
        [super beginRefreshing];
        self.refreshState = HMRefreshStateRefreshing;
    }
}

- (void)endRefreshing {
    NSLog(@"结束刷新");
    [super endRefreshing];
    
    _isRefreshing = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pulldownView.refreshIndicator stopAnimating];
        self.pulldownView.pulldownIcon.hidden = NO;
        
        self.pulldownView.pulldownIcon.transform = CGAffineTransformIdentity;
        self.pulldownView.tipLabel.text = @"下拉刷新数据";
        
        _refreshState = HMRefreshStateNormal;
    });
}

#pragma mark - KVO 相关方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (self.isRefreshing) {
        return;
    }
    
    UIScrollView *scrollView = [self scrollView];
    if (scrollView == nil) {
        return;
    }
    
    if (scrollView.isDragging) {
        if (self.refreshState == HMRefreshStateNormal && self.frame.origin.y < HMRefreshControlOffset) {
            self.refreshState = HMRefreshStatePulling;
        } else if (self.refreshState == HMRefreshStatePulling && self.frame.origin.y > HMRefreshControlOffset) {
            self.refreshState = HMRefreshStateNormal;
        }
    } else {
        if (self.refreshState == HMRefreshStatePulling) {
            self.refreshState = HMRefreshStateRefreshing;
        }
    }
}

- (UIScrollView *)scrollView {
    if (![self.superview isKindOfClass:[UIScrollView class]]) {
        return nil;
    }
    
    return (UIScrollView *)self.superview;
}

- (void)setRefreshState:(HMRefreshState)refreshState {
    _refreshState = refreshState;
    
    switch (refreshState) {
        case HMRefreshStateNormal: {
            self.pulldownView.tipLabel.text = @"下拉刷新数据";
            
            [UIView animateWithDuration:0.25 animations:^{
                self.pulldownView.pulldownIcon.transform = CGAffineTransformIdentity;
            }];
        }
            break;
        case HMRefreshStatePulling: {
            self.pulldownView.tipLabel.text = @"放开开始刷新";
            
            [UIView animateWithDuration:0.25 animations:^{
                self.pulldownView.pulldownIcon.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
            break;
        case HMRefreshStateRefreshing:
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pulldownView.tipLabel.text = @"正在刷新数据...";
                
                self.pulldownView.pulldownIcon.hidden = YES;
                [self.pulldownView.refreshIndicator startAnimating];
                
                if (!_isRefreshing) {
                    _isRefreshing = YES;
                    [self sendAction:__action to:__target forEvent:[[UIEvent alloc] init]];
                }
            });
            
            break;
    }
}

#pragma mark - 设置界面
- (void)prepareUI {
    // 1. 背景颜色
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor clearColor];
    
    if (self.subviews.count > 0) {
        [self.subviews[0] removeFromSuperview];
    }
    
    // 2. 内容视图
    _contentView = [[UIView alloc] init];
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    _contentView.translatesAutoresizingMaskIntoConstraints = false;
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_contentView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict]];
    
    // 3. 下拉刷新视图
    if (self.pulldownView == nil) {
        self.pulldownView = [[HMRefreshView alloc] init];
    }
    [_contentView addSubview:self.pulldownView];
}

@end

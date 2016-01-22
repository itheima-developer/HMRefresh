//
//  HMRefreshView.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/21.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMRefreshView.h"

@interface HMRefreshView()
/// 图像 bundle
@property (nonatomic) NSBundle *imageBundle;
/// 容器视图
@property (nonatomic) UIView *containerView;
@end

@implementation HMRefreshView
@synthesize containerView = _containerView;
@synthesize pulldownIcon = _pulldownIcon;
@synthesize refreshIndicator = _refreshIndicator;
@synthesize tipLabel = _tipLabel;
@synthesize timeLabel = _timeLabel;

#pragma mark - 构造函数
- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 220, 44)];
    if (self) {
        [self addSubview:self.containerView];
        
        [self.containerView addSubview:self.pulldownIcon];
        [self.containerView addSubview:self.refreshIndicator];
        [self.containerView addSubview:self.tipLabel];
        [self.containerView addSubview:self.timeLabel];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - HMRefreshViewDelegate
- (void)startAnimating {
    [self.refreshIndicator startAnimating];
}

- (void)stopAnimating {
    [self.refreshIndicator stopAnimating];
}

- (BOOL)isAnimating {
    return self.refreshIndicator.isAnimating;
}

- (UIActivityIndicatorView *)refreshIndicator {
    if (_refreshIndicator == nil) {
        _refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.refreshIndicator.frame = CGRectMake(0, 6, 32, 32);
    }
    return _refreshIndicator;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 8, 172, 16)];
        
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = [UIColor darkGrayColor];
        _tipLabel.text = @"正在刷新数据...";
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 24, 172, 12)];
        
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.text = @"上次刷新 2016-01-01 24:59";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UIImageView *)pulldownIcon {
    if (_pulldownIcon == nil) {
        UIImage *arrowimage = [UIImage imageNamed:@"tableview_pull_refresh" inBundle:self.imageBundle compatibleWithTraitCollection:nil];
        
        _pulldownIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 32, 32)];
        _pulldownIcon.image = arrowimage;
        _pulldownIcon.hidden = YES;
    }
    return _pulldownIcon;
}

#pragma mark - 懒加载
- (NSBundle *)imageBundle {
    if (_imageBundle == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *bundlePath = [bundle pathForResource:@"HMRefresh.bundle" ofType:nil];
        
        _imageBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return _imageBundle;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    }
    return _containerView;
}

@end

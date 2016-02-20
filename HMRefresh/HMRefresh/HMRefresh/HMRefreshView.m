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
    self = [super initWithFrame:CGRectMake(0, 0, 198, 44)];
    if (self) {
        [self addSubview:self.containerView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - HMRefreshViewDelegate
- (UIActivityIndicatorView *)refreshIndicator {
    if (_refreshIndicator == nil) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicator.frame = CGRectMake(0, 6, 32, 32);
        
        [self.containerView addSubview:indicator];
        _refreshIndicator = indicator;
    }
    return _refreshIndicator;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 8, 106, 16)];
        
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = [UIColor darkGrayColor];
        tipLabel.text = @"正在刷新数据...";
        
        [self.containerView addSubview:tipLabel];
        _tipLabel = tipLabel;
    }
    return _tipLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 24, 106, 12)];
        
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.text = @"上次刷新 01-01 00:01";
        
        [self.containerView addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (UIImageView *)pulldownIcon {
    if (_pulldownIcon == nil) {
        UIImage *arrowimage = [UIImage imageNamed:@"tableview_pull_refresh" inBundle:self.imageBundle compatibleWithTraitCollection:nil];
        
        UIImageView *pulldownIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 32, 32)];
        pulldownIcon.image = arrowimage;
        pulldownIcon.hidden = YES;
        
        [self.containerView addSubview:pulldownIcon];
        _pulldownIcon = pulldownIcon;
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
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 198, 44)];
    }
    return _containerView;
}

@end

//
//  BaiduWMRefreshView.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/25.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "BaiduWMRefreshView.h"

@interface BaiduWMRefreshView()

/// 刷新指示器
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *refreshIndicator;
/// 下拉提示图像
@property (nonatomic, weak) IBOutlet UIImageView *pulldownIcon;
/// 提示标签
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
/// 刷新时间标签
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
/// 背景图像
@property (nonatomic) UIImage *bgIcon;
@end

@implementation BaiduWMRefreshView

- (void)refreshViewDidRefreshing:(UIView<HMRefreshViewDelegate> *)refreshView refreshType:(HMRefreshType)refreshType {
    self.pulldownIcon.hidden = NO;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anim.toValue = @(2 * M_PI);
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.4;
    
    [self.pulldownIcon.layer addAnimation:anim forKey:nil];
}

- (void)refreshViewDidEndRefreshed:(UIView<HMRefreshViewDelegate> *)refreshView {
    [self.pulldownIcon.layer removeAllAnimations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = self.superview.bounds;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    // 裁切路径
    CGRect clipRect = CGRectMake(0, -rect.size.height, rect.size.width, 2 * rect.size.height);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipRect];
    [clipPath addClip];
    
    // 绘制图像
    UIImage *image = self.bgIcon;
    CGSize imageSize = image.size;
    [image drawInRect:CGRectMake(0, CGRectGetMaxY(rect) - imageSize.height, imageSize.width, imageSize.height)];
    
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithOvalInRect:clipRect];
    [[UIColor colorWithRed:251 / 255.0 green:14.0 / 255.0 blue:59.0 / 255.0 alpha:0.5] setFill];
    [fillPath fill];
}

#pragma mark - 懒加载
/// 根据屏幕宽度，生成背景图片
- (UIImage *)bgIcon {
    if (_bgIcon == nil) {
        UIImage *image = [UIImage imageNamed:@"bgicon"];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        CGFloat w = screenSize.width;
        CGFloat h = ceil(image.size.height * w / image.size.width);
        CGSize imageSize = CGSizeMake(w, h);
        
        UIGraphicsBeginImageContext(imageSize);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        
        _bgIcon = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return _bgIcon;
}

@end

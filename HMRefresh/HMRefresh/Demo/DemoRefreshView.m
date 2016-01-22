//
//  DemoRefreshView.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "DemoRefreshView.h"

@interface DemoRefreshView()
@property (nonatomic) IBOutlet UIActivityIndicatorView *refreshIndicator;
@property (nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic) IBOutlet UIImageView *pulldownIcon;
@property (nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation DemoRefreshView

- (void)startAnimating {
    [self.refreshIndicator startAnimating];
}

- (void)stopAnimating {
    [self.refreshIndicator stopAnimating];
}

- (BOOL)isAnimating {
    return self.refreshIndicator.isAnimating;
}

@end

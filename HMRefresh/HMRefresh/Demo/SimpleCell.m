//
//  SimpleCell.m
//  HMRefresh
//
//  Created by 刘凡 on 16/2/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "SimpleCell.h"
#import <Masonry/Masonry.h>

@implementation SimpleCell {
    UILabel *_contentLabel;
}

#pragma mark - 设置数据
- (void)setContent:(NSString *)content {
    _contentLabel.text = content;
}

- (NSString *)content {
    return _contentLabel.text;
}

#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        CGFloat margin = 8;
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(margin);
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
        }];
    }
    return self;
}

@end

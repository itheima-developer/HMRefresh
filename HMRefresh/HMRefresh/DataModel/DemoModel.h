//
//  DemoModel.h
//  HMRefresh
//
//  Created by 刘凡 on 16/2/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoModel : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *str;
@property (nonatomic) CGFloat rowHeight;

+ (instancetype)demoModelWithId:(NSInteger)id;

@end

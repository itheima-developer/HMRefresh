//
//  DemoModel.h
//  HMRefresh
//
//  Created by 刘凡 on 16/2/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoModel : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *str;

+ (instancetype)demoModelWithId:(NSInteger)id;

@end

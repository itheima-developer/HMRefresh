//
//  DemoModel.m
//  HMRefresh
//
//  Created by 刘凡 on 16/2/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "DemoModel.h"

@implementation DemoModel

+ (instancetype)demoModelWithId:(NSInteger)id {
    
    DemoModel *model = [[self alloc] init];
    
    model.id = id;
    model.str = self.demoString;
    
    return model;
}

+ (NSString *)demoString {
    
    NSArray *strList = @[@"新年快乐", @"万事如意", @"恭喜发财", @"大吉大利", @"马到成功", @"龙马精神"];
    
    int count = arc4random_uniform(10) + 1;
    
    NSMutableString *strM = [NSMutableString string];
    
    for (NSInteger i = 0; i < count; i++) {
        [strM appendString:strList[random() % strList.count]];
    }
    
    return strM.copy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%05zd - %@", _id, _str];
}

@end

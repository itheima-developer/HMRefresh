//
//  DataModel.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/19.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "DataModel.h"

/// 默认起始行数，默认从 20 开始刷新，如果到达 0 表示没有新的数据
static NSInteger kStartRowNumber = 20;

@implementation DataModel

- (NSMutableArray<NSNumber *> *)dataList {
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (void)loadData:(BOOL)isPullup completion:(void (^)())completion {
    
    NSAssert(completion != nil, @"必须传入完成回调");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 下拉刷新计数(取出数组第一条数据)
        NSInteger sinceId = !isPullup ? [self.dataList.firstObject integerValue] : 0;
        // 上拉刷新计数(取出数组最后一条数据)
        NSInteger maxId = isPullup ? [self.dataList.lastObject integerValue] : 0;
        
        // --- 以下代码主要用于生成测试数据 ---
        // 随机生成 0 ~ 9 条数据
        NSInteger count = arc4random_uniform(10);
        // 上拉刷新数据，不允许出现负值
        if ((maxId - count) < 0 && isPullup) {
            count = maxId;
        }
        NSLog(@"随机生成了 %zd 条数据", count);
        
        // 判断起始 id
        NSInteger startId = 0;
        if (sinceId == 0 && maxId == 0) {
            startId = kStartRowNumber;
        } else if (sinceId > 0) {
            startId = sinceId + 1;
        } else {
            startId = maxId - count;
        }
        
        // 创建数据
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < count; i++) {
            [arrayM insertObject:@(startId + i) atIndex:0];
        }
        // --- 生成测试数据完成 ---
        
        // 主线程回调 - 实际开发主要处理以下拼接数组的代码逻辑 --
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (maxId > 0) {
                [self.dataList addObjectsFromArray:arrayM];
            } else {
                NSRange range = NSMakeRange(0, arrayM.count);
                [self.dataList insertObjects:arrayM atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            }
            
            completion();
        });
    });
}

@end

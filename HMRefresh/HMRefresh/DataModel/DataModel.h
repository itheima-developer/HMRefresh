//
//  DataModel.h
//  HMRefresh
//
//  Created by 刘凡 on 16/1/19.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic) NSMutableArray <NSNumber *> *dataList;

/// 加载数据
///
/// @param isPullup   是否上拉刷新
/// @param completion 完成回调
- (void)loadData:(BOOL)isPullup completion:(void (^)())completion;

@end

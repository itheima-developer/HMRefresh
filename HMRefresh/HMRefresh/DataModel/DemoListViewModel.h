//
//  DemoListViewModel.h
//  HMRefresh
//
//  Created by 刘凡 on 16/2/13.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoModel.h"

/// 显示列表视图模型
@interface DemoListViewModel : NSObject

@property (nonatomic) NSMutableArray <DemoModel *> *dataList;

/// 加载数据
///
/// @param isPullup   是否上拉刷新
/// @param completion 完成回调
- (void)loadData:(BOOL)isPullup completion:(void (^)())completion;

@end

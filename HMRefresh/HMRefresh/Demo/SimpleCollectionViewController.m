//
//  SimpleCollectionViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/22.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "SimpleCollectionViewController.h"
#import "DataModel.h"
#import "HMRefreshControl.h"
#import "DemoCollectionViewCell.h"

@interface SimpleCollectionViewController ()
@property (nonatomic) DataModel *dataModel;
@end

@implementation SimpleCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (DataModel *)dataModel {
    if (_dataModel == nil) {
        _dataModel = [[DataModel alloc] init];
    }
    return _dataModel;
}

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 120);
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[DemoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 添加刷新控件
    HMRefreshControl *refreshControl = [[HMRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView addSubview:refreshControl];
    
    [self loadData:refreshControl];
}

- (void)loadData:(HMRefreshControl *)refreshControl {
    
    // 开始刷新
    [refreshControl beginRefreshing];
    [self.dataModel loadData:refreshControl.isPullupRefresh completion:^{
        // 结束刷新
        [refreshControl endRefreshing];
        
        // 刷新表格数据
        [self.collectionView reloadData];
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModel.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    cell.label.text = [NSString stringWithFormat:@"%@", self.dataModel.dataList[indexPath.item]];
    
    return cell;
}

@end

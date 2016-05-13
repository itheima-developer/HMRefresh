//
//  MainTableViewController.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/21.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "MainTableViewController.h"
#import "Demo/DemoControllers.h"

static NSString *cellId = @"cellId";

@interface MainTableViewController ()
/// 演示控制器数组
@property (nonatomic) NSArray <NSDictionary *>*demoControllers;
@end

@implementation MainTableViewController

- (NSArray<NSDictionary *> *)demoControllers {
    if (_demoControllers == nil) {
        _demoControllers = @[
                             @{@"groupName": @"表格演练",
                               @"controllers":
                                   @[@{@"name": @"简单表格演练", @"clsName": @"SimpleTableViewController"},
                                     @{@"name": @"简单ViewController+表格演练", @"clsName": @"SimpleViewController"},
                                     @{@"name": @"自定义表格演练", @"clsName": @"CustomTableViewController"},
                                     @{@"name": @"仿百度外卖", @"clsName": @"BaiduWMTableViewController"}]
                               },
                             @{@"groupName": @"CollectionView演练",
                               @"controllers":
                                   @[@{@"name": @"简单CollectionView演练", @"clsName": @"SimpleCollectionViewController"}]
                               }
                             ];
    }
    return _demoControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    self.title = @"刷新控件示例";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.demoControllers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.demoControllers[section][@"controllers"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSDictionary *controllerDict = [self controllerDictWithIndexPath:indexPath];
    cell.textLabel.text = controllerDict[@"name"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  self.demoControllers[section][@"groupName"];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *controllerDict = [self controllerDictWithIndexPath:indexPath];
    
    NSString *clsName = controllerDict[@"clsName"];
    Class cls = NSClassFromString(clsName);
    UIViewController *vc = [[cls alloc] init];
    
    vc.title = controllerDict[@"name"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSDictionary *)controllerDictWithIndexPath:(NSIndexPath *)indexPath {
    return self.demoControllers[indexPath.section][@"controllers"][indexPath.row];
}

@end

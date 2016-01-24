![](http://www.itheima.com/uploads/2015/08/198x57.png)

# HMRefresh 
[![Build Status](https://travis-ci.org/itheima-developer/HMRefresh.svg?branch=master)](https://travis-ci.org/itheima-developer/HMRefresh)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/HMRefresh.svg)](https://img.shields.io/cocoapods/v/HMRefresh.svg)
[![Platform](https://img.shields.io/cocoapods/p/HMRefresh.svg?style=flat)](http://cocoadocs.org/docsets/HMRefresh)

轻量级的上拉／下拉刷新控件

## 功能

* 与 `UIRefreshControl` 完全一致的接口调用方式，上手容易
* 面向协议编程，能够方便灵活地自定义视图
* 支持 `UITableView` 和 `UICollectionView` 的上／下拉刷新，不占用 `HeaderView` 和 `FooterView`
* 预加载数据功能，当显示最后一个 cell 时，能够自动刷新后续数据，网络流畅时，用户看不到上拉视图，提供更加流畅的用户体验
* 无数据设置，当重复上拉刷新数据没有结果时，会停止上拉刷新，不会频繁发起网络请求

## 屏幕截图

![](https://github.com/itheima-developer/HMRefresh/blob/master/screenshots/tableview1.gif?raw=true">)
![](https://github.com/itheima-developer/HMRefresh/blob/master/screenshots/collectionview1.gif?raw=true">)

## 系统支持

* iOS 8.0+
* Xcode 7.0

## 安装 

### CocoaPods

* 进入终端，`cd` 到项目目录，输入以下命令，建立 `Podfile`

```bash
$ pod init
```

* 在 Podfile 中输入以下内容：

```
platform :ios, '8.0'
use_frameworks!

target 'ProjectName' do
pod 'HMRefresh'
end
```

* 在终端中输入以下命令，安装或升级 Pod

```bash
# 安装 Pod，第一次使用
$ pod install

# 升级 Pod，后续使用
$ pod update
```

## 使用

### Objective-C

* 导入框架

```objc
@import HMRefresh;
```

* 在 TableViewController 的 viewDidLoad 中设置刷新控件

```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshControl = [[HMRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
}
```

* 刷新数据方法

```objc
- (void)loadData:(HMRefreshControl *)refreshControl {

    // 开始刷新
    [refreshControl beginRefreshing];
    [self.dataModal loadData:refreshControl.isPullupRefresh completion:^{
        // 结束刷新
        [refreshControl endRefreshing];

        // 刷新数据
        [self.tableView reloadData];
    }];
}
```

#### 自定义视图

* 使用 XIB 或 Storyboard 建立上拉/下拉刷新视图
* 在自定义视图的头文件中遵守协议

```objc
@interface DemoRefreshView : UIView <HMRefreshViewDelegate>

@end
```

* 代码连线到私有扩展中

```objc
/// 刷新指示器
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *refreshIndicator;
/// 下拉提示图像
@property (nonatomic, weak) IBOutlet UIImageView *pulldownIcon;
/// 提示标签
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
/// 刷新时间标签
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
```

> 提示：如果不需要可以不连线，不过属性仍然需要保留

### Swift

* 导入框架

```swift
import HMRefresh
```

* 在 TableViewController 的 viewDidLoad 中设置刷新控件

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    self.refreshControl = HMRefreshControl()
    self.refreshControl?.addTarget(self, action: "loadData:", forControlEvents: .ValueChanged)
}
```

* 刷新数据方法

```swift
@objc private func loadData(refreshControl: HMRefreshControl) {

    refreshControl.beginRefreshing()
    dataModel.loadData(refreshControl.isPullupRefresh) {
        refreshControl.endRefreshing()

        self.tableView.reloadData();
    }
}
```




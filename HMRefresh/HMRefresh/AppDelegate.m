//
//  AppDelegate.m
//  HMRefresh
//
//  Created by 刘凡 on 16/1/21.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MainTableViewController new]];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

@end

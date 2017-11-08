//
//  AppDelegate+Setting.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/13.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "AppDelegate+Setting.h"
#import "ActivityViewController.h"
#import "HomeViewController.h"
#import "ContactViewController.h"
#import "PersonViewController.h"

@implementation AppDelegate (Setting)

-(void)setRootViewController
{
    UITabBarController *tab = [[UITabBarController alloc]init];
    //设置标签栏文字和图片的颜色
    
    //设置标签栏的颜色
    tab.tabBar.barTintColor = [UIColor whiteColor];
    tab.tabBar.backgroundColor = [UIColor whiteColor];
//    tab.tabBar.tintColor = [UIColor orangeColor];
    
    NSArray * classNameArr = @[@"HomeViewController",@"ActivityViewController",@"PersonViewController",@"ContactViewController"];
    NSArray * titleArr = @[@"主页",@"活动",@"个人中心",@"客服"];
    NSArray * imageArr = @[@"common_tabbar_home_icon",@"common_tabbar_activitie_icon",@"common_tabbar_profile_icon",@"common_tabbar_services_icon"];
    NSArray * selectedImageArr = @[@"common_tabbar_home_select_icon",@"common_tabbar_activitie_select_icon",@"common_tabbar_profile_select_icon",@"common_tabbar_services_select_icon"];

    NSMutableArray * vcArr = [NSMutableArray array];
    for (int i=0; i < 4; i++) {
        ATBaseViewController * vc = [[NSClassFromString(classNameArr[i]) alloc]init];
        vc.tabBarItem.title = titleArr[i];
        NSDictionary *dictHome = [NSDictionary dictionaryWithObject:UIColorFromINTValue(151, 151, 151) forKey:NSForegroundColorAttributeName];
        [vc.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateNormal];
        NSDictionary *dictHome2 = [NSDictionary dictionaryWithObject:UIColorFromINTValue(31, 189, 214) forKey:NSForegroundColorAttributeName];
        [vc.tabBarItem setTitleTextAttributes:dictHome2 forState:UIControlStateHighlighted];

        vc.tabBarItem.image = [[UIImage imageNamed:imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [vcArr addObject:nav];
        [vc.tabBarItem setBadgeValue:@"9"];
    }
  
    tab.viewControllers = vcArr;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance]setBarTintColor:kMainColor];
}

@end

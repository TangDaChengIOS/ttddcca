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
#import "LoginViewController.h"
#import "UserModel.h"
#import "RSAEncryptor.h"

@implementation AppDelegate (Setting)

-(void)setDefaultRootViewController
{
    [[UINavigationBar appearance]setBarTintColor:kMainColor];
    UITabBarController *tab = [[UITabBarController alloc]init];
    tab.tabBar.barTintColor = [UIColor whiteColor];
    tab.tabBar.backgroundColor = [UIColor whiteColor];
    [tab setViewControllers:[self setTabBarControllerViewControllers:NO] animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
    [self getWebUrls];
}

-(void)setNoLoginRootViewController
{
    [[AppDelegate getTabBarController]setViewControllers:[self setTabBarControllerViewControllers:NO] animated:YES];
    [self getWebUrls];
}

-(void)setLoginSuccessRootViewController
{
    [[AppDelegate getTabBarController]setViewControllers:[self setTabBarControllerViewControllers:YES] animated:YES];
    [AppDelegate getTabBarController].selectedIndex = 2;
    [self getWebUrls];
}


-(NSMutableArray *)setTabBarControllerViewControllers:(BOOL)isLogin
{
    NSArray * classNameArr = nil;
    if (isLogin) {
        classNameArr = @[@"HomeViewController" ,@"ActivityViewController" ,@"PersonViewController" ,@"ContactViewController"];
    }else{
        classNameArr = @[@"HomeViewController" ,@"ActivityViewController" ,@"LoginViewController" ,@"ContactViewController"];
    }

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
        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [vcArr addObject:nav];
    }
    return vcArr;
}


//-(void)autoLogin
//{
//    NSString * passWord = [RSAEncryptor encryptStringUseLocalFile:@"5k8b22"];
//    
//    NSDictionary * dict = @{@"loginName":@"BCASDFG",
//                            @"password":passWord};
//    [RequestManager getWithPath:@"login" params:dict success:^(id JSON ,BOOL isSuccess) {
//        if (!isSuccess) {
//            TTAlert(JSON);
//            return ;
//        }
//        UserModel * model = [[UserModel alloc]init];
//        [model mj_setKeyValues:JSON];
//        model.accountName = @"BCASDFG";
//        [BSTSingle defaultSingle].user = model;
//        NSLog(@"登录成功");
//    } failure:^(NSError *error) {
//        
//    }];
//}

/**获取各种协议的地址*/
-(void)getWebUrls{
    [RequestManager getManagerDataWithPath:@"appwebUrls" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        for (NSDictionary * dict in JSON) {
            if ([dict[@"paraCode"] isEqualToString:@"register_prot"]) {
                [BSTSingle defaultSingle].registerAgreementUrl = dict[@"url"];
            }
            else if ([dict[@"paraCode"] isEqualToString:@"about"]) {
                [BSTSingle defaultSingle].aboutUSUrl = dict[@"url"];
            }
            else if ([dict[@"paraCode"] isEqualToString:@"vip_about"]) {
                [BSTSingle defaultSingle].vipExplainUrl = dict[@"url"];
            }
            else if ([dict[@"paraCode"] isEqualToString:@"ads_roll_tome"]){
                [BSTSingle defaultSingle].adsRollTime = [dict[@"content"] integerValue];
            }
            else if ([dict[@"paraCode"] isEqualToString:@"actNums"]){
                [BSTSingle defaultSingle].activityUnreadNum = [dict[@"content"] integerValue];
                
                [[AppDelegate getTabBarController].viewControllers[1].tabBarItem setBadgeValue:[ZZTextInput getBadgeValue:[BSTSingle defaultSingle].activityUnreadNum]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

+(UINavigationController *)getBoomNavigation{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UITabBarController * tabBar = (UITabBarController * )window.rootViewController;
    return tabBar.selectedViewController;
}
+(UITabBarController *)getTabBarController{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UITabBarController * tabBar = (UITabBarController * )window.rootViewController;
    return tabBar;
}


@end

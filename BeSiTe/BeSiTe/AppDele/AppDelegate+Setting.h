//
//  AppDelegate+Setting.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/13.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Setting)

-(void)setDefaultRootViewController:(BOOL)isLogin;

-(void)setNoLoginRootViewController;
-(void)setLoginSuccessRootViewController;
-(void)checkNewVersion;

+(UINavigationController *)getBoomNavigation;
+(UITabBarController *)getTabBarController;

@end

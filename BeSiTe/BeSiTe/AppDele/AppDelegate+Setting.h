//
//  AppDelegate+Setting.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/13.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Setting)

-(void)setDefaultRootViewController;
//-(void)autoLogin;
-(void)setNoLoginRootViewController;
-(void)setLoginSuccessRootViewController;


+(UINavigationController *)getBoomNavigation;
+(UITabBarController *)getTabBarController;

@end

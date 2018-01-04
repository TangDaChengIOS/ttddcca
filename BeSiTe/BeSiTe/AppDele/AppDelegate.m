//
//  AppDelegate.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/13.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Setting.h"
//#import <LocalAuthentication/LocalAuthentication.h>
#import "APPStartRunViewController.h"
#import "RSAEncryptor.h"
#import <Instabug/Instabug.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UserModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [IQKeyboardManager sharedManager].enable = YES;
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    //第一次运行APP，先加载启动页
    if (![ud boolForKey:@"FirstRunAPP"]) {
        [ud setBool:YES forKey:@"FirstRunAPP"];
        [ud synchronize];
        //加载启动页
        APPStartRunViewController * runVC = [[APPStartRunViewController alloc]init];
        kWeakSelf
        runVC.finishBlock = ^{
            [weak_self setDefaultRootViewController:NO];
        };
        
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = runVC;
        [self.window makeKeyAndVisible];
    }
    else{
        if ([UserModel isSuccessReadSavedLoginData]) {
            [self setDefaultRootViewController:YES];
            [RequestCommonData getUnReadMsgNums];
        }else{
            [self setDefaultRootViewController:NO];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNoLoginRootViewController) name:BSTLoginFailueNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginSuccessRootViewController) name:BSTLoginSuccessNotification object:nil];

    [Instabug startWithToken:@"5e0d2401c0059818a8321a1955cd1744" invocationEvent:IBGInvocationEventShake];
    return YES;
}

#pragma mark -- 横屏支持相关代码
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return _isCanRotationWindow ? UIInterfaceOrientationMaskAll: UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

//
//  AppDelegate.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/13.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Setting.h"
#import "RSAEncryptor.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setRootViewController];
 /*
    // 1> 实例化指纹识别对象
    LAContext *laCtx = [[LAContext alloc] init];
    
    // 2> 判断当前设备是否支持指纹识别功能.
    if (![laCtx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
        
        // 如果设备不支持指纹识别功能
        NSLog(@"该设备不支持指纹识别功能");
    }
    else{
    [laCtx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登陆" reply:^(BOOL success, NSError *error) {
        // 如果成功,表示指纹输入正确.
        if (success) {
            NSLog(@"指纹识别成功!");
            
        } else {
            NSLog(@"指纹识别错误,请再次尝试");
        }
    }];
    }
    
    */ 
    NSString* publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    NSString* privateKeyPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    
   NSString * str = [RSAEncryptor encryptString:@"jintianceshileyitianrsa" publicKeyWithContentsOfFile:publicKeyPath];
    NSLog(@"%@",str);
    NSLog(@"%@",[RSAEncryptor decryptString:str privateKeyWithContentsOfFile:privateKeyPath password:@"tdcdmm"]);
    
    NSString * str2 = [RSAEncryptor encryptString:@"sdasdsasdasdasdasda" publicKey:PublicKey];
    NSLog(@"%@",str2);
 
    NSString * str3 = [RSAEncryptor decryptString:str2 privateKey:@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANOcUMIPZZqKqiu+JbzmBm7VhHxZqigSm6/yvy34wj0dzNktU2mPaWC/m43QdmQ2ZFL1vBAP8DeAmP8DoEeOjzEtoGMJCjy69cCY5wXAFnmbrDLKMbQhzr3uAtsRN9eq+an24GQenvDjYKjGcS8XWLak9TUHvKAvRzjXYaR+IL4jAgMBAAECgYAerJ4YQ1sbF9arGJkn1MBB+LmHvQepX2kqDCoiY9jkOxmisatRtfQ0jhHicMF4rVnFnNFyEp1jrkR/Uus89DFVUCJi9PavJKctsxnztUB0oOaGV9DJ3BRXD1AmMFLLQFs7g+Jwjlm8wkhWrRY4T+QTHv6OET7VDgTexfi61477wQJBAO+EftIHCit7YX8DKJ8kH2v0tmmnsNJ2VMrIkR2sTh8aS/ejx20r8SpE9IHi69GrfgcF3vik76JS02thX/P0mKkCQQDiLDExr8P8f5b7gLrD64LJVu1HBDN37DaX/Cli3Xf/5RVe5rEm4MCqa1WysUG0zBNYy/PePVqelIzL1trKXaPrAkBZzKgroF4MvV5pW0rQl598Pyxg4nEmBx11Rcs6f85uVNKkjvAHG1F40o+FXwmg+5XtliLpwBTkG/+OI9zwvwS5AkB50NeGLWbfvlCxkToGf/hnPNx7nXWjJ6SX44be6u3Q86+494N+rxrWLw1vOy1qlWfuMZtdnaoLM3NJ7qTUze6VAkA6JgJo53N0hgkHUepNx1gRzQDVZ2L50J0ebgEdAN7mBNLf/4UsZWLUOGTdiPECaW+Q02m9Y2tlzQrXtdWHP4jZ"];
    NSLog(@"%@",str3);
    return YES;
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

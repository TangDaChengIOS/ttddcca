//
//  RequestManager.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/17.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate+Setting.h"

@implementation RequestManager

+ (void)commonRequestWithPath:(NSString *)path params:(NSDictionary *)params method:(NSString *)method success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure :(BOOL)isManagerData{
    
    NSString * baseUrl = (isManagerData ? ManagerBaseURL : ProfessionalBaseURL);
    if ([path isEqualToString:@"sendSmsCode"] || [path isEqualToString:@"verify"]) {
        baseUrl = SendCodeURL;
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,path];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSSet *set = [[NSSet alloc] initWithObjects:@"text/plain",@"text/html", @"application/json", nil];
    manager.responseSerializer.acceptableContentTypes = set;
    manager.requestSerializer.timeoutInterval = 10;
    if ([BSTSingle defaultSingle].user) {
        [manager.requestSerializer setValue:[BSTSingle defaultSingle].user.token forHTTPHeaderField:@"ACCESS_TOKEN"];
    }
    
    NSMutableDictionary *allParams = [params mutableCopy];
    if ([method isEqualToString:@"GET"]) {
        
        [manager GET:url parameters:allParams progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success == nil) return;
            if ([responseObject[@"retCode"] integerValue] == 0)
            {
                if ([responseObject objectForKey:@"data"]) {
                    success(responseObject[@"data"],YES);
                }else{
                    success(responseObject[@"page"],YES);
                }
            }
            else{
                if ([task.originalRequest.URL.path hasSuffix:@"login"])
                {
                    success(responseObject[@"retMsg"],NO);
                    return;
                }
                
                if ([self isNeedPresentLoginPageForReturnCode:[responseObject[@"retCode"] integerValue]]) {
                    return;
                }
                success(responseObject[@"retMsg"],NO);
                MyLog(@"GET Error URL:%@",[task.response valueForKey:@"URL"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1001) {
                if (failure) {
                    failure(nil);
                }
                TTAlert(kOutTimeError);
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }];
        
    }else {//6.POST请求
        
        [manager POST:url parameters:allParams progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            MyLog(@"SUCCESS URL:%@",[task.response valueForKey:@"URL"]);
            if (success == nil) return;
            if ([responseObject[@"retCode"] integerValue] == 0)
            {
                if ([responseObject objectForKey:@"data"]) {
                    success(responseObject[@"data"],YES);
                }else{
                    success(responseObject[@"page"],YES);
                }
            }
            else{
                if ([self isNeedPresentLoginPageForReturnCode:[responseObject[@"retCode"] integerValue]]) {
                    return;
                }
                success(responseObject[@"retMsg"],NO);
                MyLog(@"GET Error URL:%@",[task.response valueForKey:@"URL"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1001) {
                if (failure) {
                    failure(nil);
                }
                TTAlert(kOutTimeError);
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }];
    }
}


+(BOOL)isNeedPresentLoginPageForReturnCode:(NSInteger)returnCode{
    if (returnCode != 1017 && returnCode != 1003) {
        return  NO;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSavingUserInfoKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [BSTSingle defaultSingle].user = nil;
    [MBProgressHUD hideHUDForView:nil];
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!delegate.isShowNoLogin) {
        [[NSNotificationCenter defaultCenter]postNotificationName:BSTLoginFailueNotification object:nil];
        TTAlert(@"登录超时，请重新登录！");
    }
    return YES;
}


+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure
{
    [self commonRequestWithPath:path params:params method:@"POST" success:success failure:failure :NO];
}

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure
{
    [self commonRequestWithPath:path params:params method:@"GET" success:success failure:failure :NO];
}

/**管理平台POST*/
+ (void)postManagerDataWithPath:(NSString *)path params:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure
{
    [self commonRequestWithPath:path params:params method:@"POST" success:success failure:failure :YES];
}
/**管理平台GET*/
+ (void)getManagerDataWithPath:(NSString *)path params:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure
{
    [self commonRequestWithPath:path params:params method:@"GET" success:success failure:failure :YES];
}
@end

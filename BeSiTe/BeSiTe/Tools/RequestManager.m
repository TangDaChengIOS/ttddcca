//
//  RequestManager.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/17.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation RequestManager

+ (void)commonRequestWithPath:(NSString *)path params:(NSDictionary *)params method:(NSString *)method success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure :(BOOL)isManagerData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",(isManagerData ? ManagerBaseURL : ProfessionalBaseURL),path];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSSet *set = [[NSSet alloc] initWithObjects:@"text/plain",@"text/html", @"application/json", nil];
    manager.responseSerializer.acceptableContentTypes = set;
    manager.requestSerializer.timeoutInterval = 90;
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
                success(responseObject[@"retMsg"],NO);
                MyLog(@"GET Error URL:%@",[task.response valueForKey:@"URL"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MyLog(@"GET Error URL:%@",[task.response valueForKey:@"URL"]);
            MyLog(@"Error:%@",error.debugDescription);
            if (failure == nil) return;
            failure(error);
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
                success(responseObject[@"retMsg"],NO);
                MyLog(@"GET Error URL:%@",[task.response valueForKey:@"URL"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            MyLog(@"ERROR URL:%@",[task.response valueForKey:@"URL"]);
            if (failure == nil) return;
            failure(error);
        }];
    }
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

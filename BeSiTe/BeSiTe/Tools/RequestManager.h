//
//  RequestManager.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/17.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestSuccessBlock)(id JSON,BOOL isSuccess);
typedef void (^RequestFailureBlock)(NSError *error);

//业务平台
//#define ProfessionalBaseURL @"http://172.104.68.95/app/"
//#define ProfessionalBaseURL @"http://139.162.90.172/app/"
#define ProfessionalBaseURL @"http://172.104.54.176:8080/app/"



//管理平台
#define ManagerBaseURL @"http://47.94.220.227:81/"

@interface RequestManager : NSObject

/**业务平台POST*/
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure;

/**业务平台GET*/
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure;

/**管理平台POST*/
+ (void)postManagerDataWithPath:(NSString *)path params:(NSDictionary *)params  success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure;

/**管理平台GET*/
+ (void)getManagerDataWithPath:(NSString *)path params:(NSDictionary *)params  success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure;
@end

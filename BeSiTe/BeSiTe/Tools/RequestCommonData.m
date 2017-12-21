//
//  RequestCommonData.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RequestCommonData.h"

@implementation RequestCommonData


+(void)getUnReadMsgNums
{
    [RequestManager getManagerDataWithPath:@"user/msgNums" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            return ;
        }
        [[BSTSingle defaultSingle] mj_setKeyValues:JSON];
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetUnReadMsgNumsSuccessNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
}

@end

//
//  RequestCommonData.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGetUnReadMsgNumsSuccessNotification @"kGetUnReadMsgNumsSuccessNotification"

@interface RequestCommonData : NSObject

/**获取未读消息数*/
+(void)getUnReadMsgNums;

@end

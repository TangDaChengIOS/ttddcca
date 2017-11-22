//
//  MoneyRecordModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface MoneyRecordModel : ATBaseModel

@property (nonatomic,copy)NSString * cardNo;//	string	卡号
@property (nonatomic,copy)NSString * amount;//	string	金额
@property (nonatomic,copy)NSString * status;//	string	状态:以接口返回的描述为准
@property (nonatomic,copy)NSString * createdTime;//	string	时间
@property (nonatomic,copy)NSString * seqNo;//	string	流水号
@property (nonatomic,copy)NSString * notes;//	string	备注
@property (nonatomic,copy)NSString * type;//	string	类型

@property (nonatomic,copy)NSString * point;//	string	使用积分数
@property (nonatomic,copy)NSString * num;//	string	奖励数量
@property (nonatomic,copy)NSString * account;//	string	朋友的账号

@end

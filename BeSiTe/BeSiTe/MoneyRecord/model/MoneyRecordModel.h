//
//  MoneyRecordModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

typedef NS_ENUM(NSInteger,RecordDetailControlType) {
    RecordDetailControlType_QuKuan = 0,//取款
    RecordDetailControlType_CunKuan,//存款
    RecordDetailControlType_ZhuanZhang,//转账
    RecordDetailControlType_YouHui,//优惠
    RecordDetailControlType_TJLJ = 5,//推荐礼金
    RecordDetailControlType_JiFenTop,//积分
    RecordDetailControlType_JiFenBoom//积分
};

typedef NS_ENUM(NSInteger,RecordCellType) {
    RecordCellType_QuKuan = 0,//取款
    RecordCellType_CunKuan,//存款
    RecordCellType_ZhuanZhang,//转账
    RecordCellType_YouHui,//优惠
    RecordCellType_JiFen,//积分
    RecordCellType_TJLJ,//推荐礼金
    RecordCellType_JiFenTop,
    RecordCellType_JiFenBoom
};

@interface MoneyRecordModel : ATBaseModel

@property (nonatomic,copy)NSString * cardNo;//	string	卡号
@property (nonatomic,copy)NSString * amount;//	string	金额 / 兑换数量
@property (nonatomic,copy)NSString * status;//	string	状态:以接口返回的描述为准
@property (nonatomic,copy)NSString * statusDesc;//	string	状态:以接口返回的描述为准

@property (nonatomic,copy)NSString * createdTime;//	string	时间
@property (nonatomic,copy)NSString * seqNo;//	string	流水号
@property (nonatomic,copy)NSString * notes;//	string	备注
@property (nonatomic,copy)NSString * type;//	string	类型

@property (nonatomic,copy)NSString * point;//	string	使用积分数
@property (nonatomic,copy)NSString * num;//	string	奖励数量
@property (nonatomic,copy)NSString * account;//	string	朋友的账号
@property (nonatomic,copy)NSString * points;//	string	获取积分数

@end

//
//  MoneyRecordDetailViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/31.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

typedef NS_ENUM(NSInteger,RecordDetailControlType) {
    RecordDetailControlType_QuKuan = 0,//取款
    RecordDetailControlType_CunKuan,//存款
    RecordDetailControlType_ZhuanZhang,//转账
    RecordDetailControlType_YouHui,//优惠
    RecordDetailControlType_TJLJ = 5,//推荐礼金
    RecordDetailControlType_JiFenTop,//积分
    RecordDetailControlType_JiFenBoom//积分
};
@interface MoneyRecordDetailViewController : ATBaseViewController

@property (nonatomic,assign) RecordDetailControlType detailControlType;

@end

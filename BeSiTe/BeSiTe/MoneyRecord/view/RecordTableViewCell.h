//
//  RecordTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/31.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyRecordModel.h"

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

#define kRecordTableViewCellReuseID @"kRecordTableViewCellReuseID"

/**记录Cell*/
@interface RecordTableViewCell : UITableViewCell

@property (nonatomic,assign) RecordCellType cellType;
-(void)setCell;
-(void)setCellWithModel:(MoneyRecordModel *)model andCellType:(RecordCellType)cellType;

-(void)setTopCellWithVCType:(RecordDetailControlType)detailVCType;
@end

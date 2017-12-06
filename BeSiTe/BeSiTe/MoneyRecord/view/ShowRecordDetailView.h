//
//  ShowRecordDetailView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/4.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyRecordModel.h"

@interface ShowRecordDetailView : UIView

@property (nonatomic,assign) RecordCellType recordType;
@property (nonatomic,strong) MoneyRecordModel * model;

+(void)showWithModel:(MoneyRecordModel *)model andRecordType:(RecordCellType)recordType;

@end

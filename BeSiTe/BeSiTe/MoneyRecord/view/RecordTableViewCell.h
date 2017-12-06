//
//  RecordTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/31.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyRecordModel.h"



#define kRecordTableViewCellReuseID @"kRecordTableViewCellReuseID"

/**记录Cell*/
@interface RecordTableViewCell : UITableViewCell

@property (nonatomic,assign) RecordCellType cellType;
-(void)setCell;
-(void)setCellWithModel:(MoneyRecordModel *)model andCellType:(RecordCellType)cellType;

-(void)setTopCellWithVCType:(RecordDetailControlType)detailVCType;
@end

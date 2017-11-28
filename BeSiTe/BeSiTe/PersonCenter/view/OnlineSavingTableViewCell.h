//
//  OnlineSavingTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/27.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlinePayModel.h"

#define kOnlineSavingTableViewCellReuseID @"kOnlineSavingTableViewCellReuseID"
@interface OnlineSavingTableViewCell : UITableViewCell

-(void)setCellWithModel:(OnlinePayModel *)payModel;
-(void)setCellSelected;

@end

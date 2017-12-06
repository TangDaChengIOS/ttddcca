//
//  BankTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/6.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"
#import "MyBankModel.h"

#define kBankTableViewCellReuseID @"kBankTableViewCellReuseID"
@interface BankTableViewCell : UITableViewCell

-(void)setCellWithModel:(BankModel *)model;

-(void)setMyBankCellWithModel:(MyBankModel *)model;

@end

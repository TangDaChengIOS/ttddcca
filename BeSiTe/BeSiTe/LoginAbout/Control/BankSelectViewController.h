//
//  BankSelectViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/6.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"
#import "BankTableViewCell.h"

typedef NS_ENUM(NSUInteger, BankSelectVCEnterType) {
    BankSelectVCEnterTypeDefault = 0,    //默认，只显示所有银行列表
    BankSelectVCEnterTypeHaveOtherData, //显示所有银行，并显示已有银行卡
};
/**银行选择*/
@interface BankSelectViewController : ATBaseViewController
@property (nonatomic,assign) BOOL isHaveOtherData;
@property (nonatomic,copy) NSArray * myBankDataSource;

@property (nonatomic,copy) void (^selectBankBlock)(BankModel * model);
@property (nonatomic,copy) void (^selectMyBankBlock)(MyBankModel * model);

@end

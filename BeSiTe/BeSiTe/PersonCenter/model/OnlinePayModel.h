//
//  OnlinePayModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/27.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface OnlinePayModel : ATBaseModel

@property (nonatomic,copy) NSString * payName;//	string	名称
@property (nonatomic,copy) NSString * payCode;//	string	CODE
@property (nonatomic,copy) NSString * icon;//	string	图标
@property (nonatomic,copy) NSString * minAmount;//	int	最低支付金额
@property (nonatomic,copy) NSString * maxAmount;//	int	最高支付金额
@property (nonatomic,assign) NSInteger  status;//	int	1:正常 2:维护中

-(NSAttributedString *)getMoneyCoverAttributedString;

@end

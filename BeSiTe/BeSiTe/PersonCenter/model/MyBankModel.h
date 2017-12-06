//
//  MyBankModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/28.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface MyBankModel : ATBaseModel

@property (nonatomic,copy) NSString * tagId;//	string	ID(0,1,2),一个用户只可添加3张银行卡
@property (nonatomic,copy) NSString * tagName;//	string	标签名称
@property (nonatomic,copy) NSString * bankName;//	string	银行名称
@property (nonatomic,copy) NSString * cardNo;//	string	银行卡号/存折号
@property (nonatomic,copy) NSString * bankAddr;//	string	开户行地址
@property (nonatomic,copy) NSString * bankCode;//	string	银行CODE

@property (nonatomic,copy) NSString * icon;//	string	图标


@end

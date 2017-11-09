//
//  ContactModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@class ContactDetailModel;

@interface ContactModel : ATBaseModel

@property (nonatomic,strong) ContactDetailModel * comp_wechat;
@property (nonatomic,strong) ContactDetailModel * customer_hotline;
@property (nonatomic,strong) ContactDetailModel * customer_online;
@property (nonatomic,strong) ContactDetailModel * customer_qq;
@property (nonatomic,strong) ContactDetailModel * hotline;
@property (nonatomic,strong) ContactDetailModel * off_wechat;

@end

@interface ContactDetailModel : ATBaseModel
@property (nonatomic,copy) NSString * paraCode;//	string	参数名
@property (nonatomic,assign) NSInteger type;//	int	1:文本 2:图片
@property (nonatomic,copy) NSString * content;//	string	内容
@property (nonatomic,copy) NSString * description;//	string	描述

@end

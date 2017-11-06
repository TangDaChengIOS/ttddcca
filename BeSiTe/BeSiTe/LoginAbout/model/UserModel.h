//
//  UserModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/3.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface UserModel : ATBaseModel

@property (nonatomic,copy) NSString * userId;//	string	用户ID
@property (nonatomic,copy) NSString * userName;//	string	用户姓名
@property (nonatomic,copy) NSString * mobile;//	string	手机号码
@property (nonatomic,copy) NSString * mobileVerified;//	string	手机号码是否已验证 0:否，1:是
@property (nonatomic,copy) NSString * email;//	string	邮箱地址
@property (nonatomic,copy) NSString * emailVerified;//	string	邮箱地址是否已验证 0:否，1:是

/**VIP等级1~7代表： 普通会员 ~ VIP1级会员 ~ VIP6级会员*/
@property (nonatomic,copy) NSString * vipLevel;
@property (nonatomic,copy) NSString * token;//	string	用户令牌

@end

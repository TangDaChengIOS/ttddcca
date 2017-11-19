//
//  ActivityModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/10.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface ActivityModel : ATBaseModel

@property (nonatomic,copy) NSString * title;//	string	标题
@property (nonatomic,copy) NSString * icon;//	string	图标
@property (nonatomic,assign) NSInteger type;//	int	1:普通H5 2:游戏
@property (nonatomic,copy) NSString * content;//	string	内容
@property (nonatomic,copy) NSString * gameCode;//	string	游戏CODE
@property (nonatomic,copy) NSString * companyCode;//	string	平台CODE
@property (nonatomic,copy) NSString * createdTime;//	string	创建日期


@end

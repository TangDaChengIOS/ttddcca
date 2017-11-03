//
//  BannerADSModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface BannerADSModel : ATBaseModel
@property (nonatomic,copy) NSString * title;//	string	标题
@property (nonatomic,copy) NSString * imgUrl;//	string	图片
@property (nonatomic,assign) NSInteger type;//	int	1:普通H5 2:游戏
@property (nonatomic,copy) NSString * gameCode;//	string	游戏CODE
@property (nonatomic,copy) NSString * companyCode;//	string	平台CODE
@property (nonatomic,copy) NSString * webUrl;//	string	H5页面地址


@end

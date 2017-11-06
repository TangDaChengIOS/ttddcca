//
//  GamesCompanyModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"
/**游戏平台model*/
@interface GamesCompanyModel : ATBaseModel

@property (nonatomic,copy) NSString * companyCode;//	string	平台CODE
@property (nonatomic,copy) NSString * companyName;//	string	平台名

@property (nonatomic,copy) NSString * mainIcon;//	string	首页展示图标
@property (nonatomic,copy) NSString * classIcon;//	string	分类展示图标
@property (nonatomic,copy) NSString * classIconSel;//	string	分类展示图标_选中状态

@property (nonatomic,copy) NSString * listIcon;//	string	列表展示图标

@property (nonatomic,assign) BOOL isNew;//	int	是否最新0:否 1:是
@property (nonatomic,assign) BOOL isHot;//	int	是否最热0:否 1:是
@property (nonatomic,assign) BOOL mainShow;//	int	首页是否显示0:否 1:是

@end

//
//  GamesModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"
/**游戏model*/
@interface GamesModel : ATBaseModel

@property (nonatomic,copy) NSString * gameCode;//	string	游戏ID
@property (nonatomic,copy) NSString * companyCode;//	string	平台CODE
@property (nonatomic,copy) NSString * icon;//	string	图标
@property (nonatomic,copy) NSString * gameName;//	string	游戏名
@property (nonatomic,assign) BOOL  isHot;//热门
@property (nonatomic,assign) BOOL  isNew;//最新

@end

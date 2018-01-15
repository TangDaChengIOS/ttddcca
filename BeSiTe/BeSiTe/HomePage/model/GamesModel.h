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
@property (nonatomic,copy) NSString * imgUrl;
@property (nonatomic,copy) NSString * gameName;//	string	游戏名
@property (nonatomic,assign) BOOL  isHot;//热门
@property (nonatomic,assign) BOOL  isNew;//最新

@property (nonatomic,copy) NSString * gameUrl;//游戏链接
@property (nonatomic,copy) NSString * tryUrl;//试玩链接
@property (nonatomic,assign) CGFloat  star;//星级
@property (nonatomic,assign) BOOL  isTry;//是否可以试玩
@property (nonatomic,assign) BOOL  isFav;//是否收藏


-(UIImage *)getTypeImage;

/**收藏、取消收藏后 刷新缓存*/
-(void)refreshCaches;
@end

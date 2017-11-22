//
//  GamesMenuView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamesModel.h"

/**展示游戏菜单页面*/
@interface GamesMenuView : UIView
@property (nonatomic,copy) void (^tryPlayBlock)();
@property (nonatomic,strong) GamesModel * model;
+(void)showWithModel:(GamesModel *)model;

@end

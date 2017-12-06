//
//  GameItemCollectionViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamesModel.h"

#define kGameItemCollectionViewCellReuseID @"kGameItemCollectionViewCellReuseID"
/**游戏cell*/
@interface GameItemCollectionViewCell : UICollectionViewCell
-(void)setCellWithModel:(GamesModel *)model;
-(void)setCanCancelCollecWithFinishBlock:(void (^)())finishCancel;
@end

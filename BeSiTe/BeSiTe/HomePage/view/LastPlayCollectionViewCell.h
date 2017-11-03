//
//  LastPlayCollectionViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/21.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamesModel.h"

#define kLastPlayCollectionViewCellReuseID @"kLastPlayCollectionViewCellReuseID"
#define kLastPlayCollectionViewCellReuseID2 @"kLastPlayCollectionViewCellReuseID2"

@interface LastPlayCollectionViewCell : UICollectionViewCell
-(void)setCellWithModel:(GamesModel *)model;

@end

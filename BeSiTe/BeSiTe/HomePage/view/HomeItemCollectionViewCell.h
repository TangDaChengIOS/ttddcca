//
//  HomeItemCollectionViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/21.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamesCompanyModel.h"

typedef NS_ENUM(NSInteger,HomeItemType) {
    HomeItemTypeDefault =0,
    HomeItemTypeNodata
};

#define kHomeItemCollectionViewCellReuseID @"kHomeItemCollectionViewCellReuseID"
@interface HomeItemCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) HomeItemType itemType;
-(void)setCellWithModel:(GamesCompanyModel *)model;
@end

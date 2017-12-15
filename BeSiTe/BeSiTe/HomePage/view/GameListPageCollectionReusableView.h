//
//  GameListPageCollectionReusableView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGameListPageCollectionReusableViewReuseID @"kGameListPageCollectionReusableViewReuseID"
@interface GameListPageCollectionReusableView : UICollectionReusableView

@property (nonatomic,assign) BOOL isShowResult;

-(void)setIsShowResult:(BOOL)isShowResult;

-(void)setCellWithCompanyName:(NSString *)companyName andNums:(NSInteger)nums;

@end

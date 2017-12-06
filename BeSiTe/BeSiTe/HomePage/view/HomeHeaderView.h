//
//  HomeHeaderView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

/**首页顶部*/
@interface HomeHeaderView : UIView

@property (nonatomic,strong) SDCycleScrollView * bannerView;//轮播图

@property (nonatomic,assign) BOOL isRequestData;

-(void)refreshData;

@end

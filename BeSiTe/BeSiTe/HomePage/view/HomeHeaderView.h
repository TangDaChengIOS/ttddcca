//
//  HomeHeaderView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**首页顶部*/
@interface HomeHeaderView : UIView

@property (nonatomic,assign) BOOL isRequestData;

-(void)refreshData;

@end

//
//  GamesCanScrollTipsView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/12.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesCanScrollTipsView : UIView

@property (nonatomic,copy) void (^completeBlock)();

+(void)showOnView:(UIView *)superView withFinshBlock:(void(^)()) completeBlock;

@end

//
//  GameListPageHeaderView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJScrollTextView.h"

/**游戏列表页顶部*/
@interface GameListPageHeaderView : UIView
@property (nonatomic,strong) LMJScrollTextView * scrollTextView;

@property (nonatomic,assign) NSInteger selectedItem;
@property (nonatomic,copy) void (^selectGameCompanyBlock)(NSString * code);
@property (nonatomic,copy) void (^gotoSearchBlock)();

@end

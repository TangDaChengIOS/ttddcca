//
//  RecordExchangeView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/29.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"
/**积分兑换*/
@interface RecordExchangeView : ATTranslucentView
@property (nonatomic,copy) void (^completeBlock)();

+(void)showWithFinshBlock:(void(^)()) completeBlock;

@end

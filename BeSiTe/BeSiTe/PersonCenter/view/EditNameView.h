//
//  EditNameView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"

/**编辑姓名*/
@interface EditNameView : ATTranslucentView

@property (nonatomic,copy) void (^completeBlock)();

+(void)showWithFinshBlock:(void(^)()) completeBlock;

@end

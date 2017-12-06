//
//  EditEmailView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/1.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"

/**修改邮箱*/
@interface EditEmailView : ATTranslucentView

@property (nonatomic,copy) void (^completeBlock)();

+(void)showWithFinshBlock:(void(^)()) completeBlock;


@end

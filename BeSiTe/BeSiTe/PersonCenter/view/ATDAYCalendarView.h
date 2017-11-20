//
//  ATDAYCalendarView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/19.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"
#import "SKConstant.h"

typedef void (^finishSelectBlock)(NSString * dateStr);
@interface ATDAYCalendarView : ATTranslucentView
@property (nonatomic,copy) finishSelectBlock block;

+(void)showWithFinishBlock:(finishSelectBlock)block;

@end

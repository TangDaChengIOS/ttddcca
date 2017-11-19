//
//  UIButton+TimerCount.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/17.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Completion)(UIButton *countDownButton);

/**倒计时*/
@interface UIButton (TimerCount)

/**
 *  开始倒计时
 *
 *  @param startTime  倒计时时间
 *  @param completion 倒计时结束执行的Block
 */
- (void)countDownFromTime:(NSInteger)startTime completion:(Completion)completion;




@end

//
//  UIButton+TimerCount.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/17.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "UIButton+TimerCount.h"

@implementation UIButton (TimerCount)

- (void)countDownFromTime:(NSInteger)startTime completion:(Completion)completion {
    __weak typeof(self) weakSelf = self;
    // 剩余的时间（必须用__block修饰，以便在block中使用）
    __block NSInteger remainTime = startTime;
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每隔1s钟执行一次
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 在queue中执行event_handler事件
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) { // 倒计时结束
            dispatch_source_cancel(timer);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.enabled = YES;
                completion(weakSelf);
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", remainTime];
            // 回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,@"s"] forState:UIControlStateDisabled];
//                [weakSelf setBackgroundImage:[UIImage createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
                weakSelf.enabled = NO;
            });
            remainTime--;
        }
    });
    dispatch_resume(timer);
}



@end
//作者：MooneyWang
//链接：http://www.jianshu.com/p/fbef5dfe4e88
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

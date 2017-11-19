//
//  ATDAYCalendarView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/19.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATDAYCalendarView.h"

@interface ATDAYCalendarView ()
@property (nonatomic,strong) DAYCalendarView * calendarView;
@end

@implementation ATDAYCalendarView

-(instancetype)init
{
    if (self = [super init]) {
        _calendarView = [[DAYCalendarView alloc]initWithFrame:CGRectMake(0, MAXHEIGHT - 360, MAXWIDTH, 300)];
        _calendarView.selectedIndicatorColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        _calendarView.backgroundColor = kWhiteColor;
        [self addSubview:_calendarView];
        
        UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, _calendarView.maxY, MAXWIDTH, 60)];
        view.backgroundColor = kWhiteColor;
        [self addSubview:view];
        ATNeedBorderButton * button = [[ATNeedBorderButton alloc]initWithFrame:CGRectMake(15,10, MAXWIDTH - 30, 40)];
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finishedSelectedDate) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    return self;
}


-(void)finishedSelectedDate{
    NSLog(@"%@",_calendarView.selectedDate.description);
}


+(void)show{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    ATDAYCalendarView * view = [[ATDAYCalendarView alloc]init];
    [window addSubview:view];
}





@end

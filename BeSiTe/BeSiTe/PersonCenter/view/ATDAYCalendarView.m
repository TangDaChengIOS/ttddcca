//
//  ATDAYCalendarView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/19.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATDAYCalendarView.h"
#import "ASBirthSelectSheet.h"

@interface ATDAYCalendarView ()<SKCalendarViewDelegate>
@property (nonatomic, strong) SKCalendarView * calendarView;
@property (nonatomic,strong) UIButton * preMonthBtn;
@property (nonatomic,strong) UIButton * nextMonthBtn;
@property (nonatomic,strong) UILabel * YearMonthLabel;

@end

@implementation ATDAYCalendarView

-(instancetype)init
{
    if (self = [super init]) {
        
        UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, MAXHEIGHT - 370, MAXWIDTH, 370)];
        view.backgroundColor = kWhiteColor;
        [self addSubview:view];
        
        _preMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 80, 40)];
        [_preMonthBtn setImage:[KIMAGE(@"prev") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _preMonthBtn.contentMode = UIViewContentModeCenter;
        [_preMonthBtn addTarget:self action:@selector(checkLastMonthCalendar) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_preMonthBtn];
        
        _nextMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(MAXWIDTH - 95, 0, 80, 40)];
        [_nextMonthBtn setImage:KIMAGE(@"next") forState:UIControlStateNormal];
        [_nextMonthBtn addTarget:self action:@selector(checkNextMonthCalendar) forControlEvents:UIControlEventTouchUpInside];
        _nextMonthBtn.contentMode = UIViewContentModeCenter;
        [view addSubview:_nextMonthBtn];
        
        _YearMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(MAXWIDTH/ 2 - 50, 10, 100, 20)];
        _YearMonthLabel.textColor = kBlackColor;
        _YearMonthLabel.font = kFont(15);
        _YearMonthLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_YearMonthLabel];
        
        [view addSubview:self.calendarView];
        self.YearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月", @(_calendarView.year), @(_calendarView.month)];// 公历年
        
//        ATNeedBorderButton * button = [[ATNeedBorderButton alloc]initWithFrame:CGRectMake(self.calendarView.left,self.calendarView.maxY + 10, self.calendarView.width, 40)];
//        button.backgroundColor = [UIColor orangeColor];
//        [button setTitle:@"确定" forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(finishedSelectedDate) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:button];
    }
    return self;
}

#pragma mark - 日历设置
- (SKCalendarView *)calendarView
{
    if (!_calendarView) {
        _calendarView = [[SKCalendarView alloc] initWithFrame:CGRectMake(self.center.x - 150, 50, 300, 300)];
        _calendarView.layer.cornerRadius = 5;
        _calendarView.layer.borderColor = [UIColor blackColor].CGColor;
        _calendarView.layer.borderWidth = 0.5;
        _calendarView.delegate = self;// 获取点击日期的方法，一定要遵循协议
        _calendarView.calendarTodayTitleColor = [UIColor redColor];// 今天标题字体颜色
        _calendarView.calendarTodayTitle = @"今日";// 今天下标题
        _calendarView.dateColor = [UIColor orangeColor];// 今天日期数字背景颜色
        _calendarView.calendarTodayColor = [UIColor whiteColor];// 今天日期字体颜色
        _calendarView.dayoffInWeekColor = [UIColor redColor];
        _calendarView.springColor = [UIColor colorWithRed:48 / 255.0 green:200 / 255.0 blue:104 / 255.0 alpha:1];// 春季节气颜色
        _calendarView.summerColor = [UIColor colorWithRed:18 / 255.0 green:96 / 255.0 blue:0 alpha:8];// 夏季节气颜色
        _calendarView.autumnColor = [UIColor colorWithRed:232 / 255.0 green:195 / 255.0 blue:0 / 255.0 alpha:1];// 秋季节气颜色
        _calendarView.winterColor = [UIColor colorWithRed:77 / 255.0 green:161 / 255.0 blue:255 / 255.0 alpha:1];// 冬季节气颜色
        _calendarView.holidayColor = [UIColor redColor];//节日字体颜色
    }
    return _calendarView;
}

#pragma mark - 查看上/下一月份日历
- (void)checkNextMonthCalendar
{
    self.calendarView.checkNextMonth = YES;// 查看下月
    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:YES];
    _YearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];// 公历年
}

- (void)checkLastMonthCalendar
{
    self.calendarView.checkLastMonth = YES;// 查看上月
    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:NO];
    _YearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];// 公历年
}


- (void)selectDateWithRow:(NSUInteger)row{
    NSString * dateStr = [NSString stringWithFormat:@"%@-%02lu-%02ld",@(self.calendarView.year), (unsigned long)self.calendarView.month, (long)[self.calendarView.dayForSelect integerValue]];

    if (self.block) {
        self.block(dateStr);
    }
    [self removeFromSuperview];
}

//-(void)finishedSelectedDate{
//    if (self.calendarView.dayForSelect.length <= 0) {
//        TTAlert(@"请选择一个日期");
//        return;
//    }
//    NSString * dateStr = [NSString stringWithFormat:@"%@-%02lu-%02ld",@(self.calendarView.year), (unsigned long)self.calendarView.month, (long)[self.calendarView.dayForSelect integerValue]];
//    NSLog(@"%@",dateStr);
//    if (self.block) {
//        self.block(dateStr);
//        [self removeFromSuperview];
//    }
//}

+(void)showWithFinishBlock:(finishSelectBlock)block{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    ATDAYCalendarView * view = [[ATDAYCalendarView alloc]init];
    view.block = block;
    [window addSubview:view];
}





@end

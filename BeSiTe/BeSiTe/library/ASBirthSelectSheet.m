//
//  ASBirthSelectSheet.m
//  ASBirthSheet
//
//  Created by Ashen on 15/12/8.
//  Copyright © 2015年 Ashen. All rights reserved.
//

#import "ASBirthSelectSheet.h"
#import <UIKit/UIKit.h>


@interface ASBirthSelectSheet()


@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *btnDone;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end
@implementation ASBirthSelectSheet

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEmpty:)];
        [self addGestureRecognizer:tap];
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, MAXHEIGHT - 290 - 70, MAXWIDTH - 20, 290)];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 3;
    _containerView.layer.masksToBounds = YES;
    _datePicker =  [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 10, MAXWIDTH - 20, 200)];
    [_datePicker setDate:[NSDate date] animated:YES];
    [_datePicker setMaximumDate:[NSDate date]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];

    [_datePicker setMinimumDate:[self.formatter dateFromString:@"1900-01-01日"]];
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [_containerView addSubview:_datePicker];
    
    
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.frame = CGRectMake(-0.4, CGRectGetMaxY(_datePicker.frame), MAXWIDTH - 19.2, 40);
    [_btnDone setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btnDone setTitle:@"确定" forState:UIControlStateNormal];
    [_btnDone addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnDone.layer.borderWidth = 0.3;
    _btnDone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_containerView addSubview:_btnDone];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCancel.frame = CGRectMake(0, CGRectGetMaxY(_btnDone.frame), MAXWIDTH - 20, 40);
    [_btnCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_btnCancel];
    
    [self addSubview:_containerView];
}

#pragma mark - private method
- (void)clickEmpty:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}
#pragma mark - Action
- (void)doneAction:(UIButton *)btn {
    if (self.GetSelectDate) {
        _GetSelectDate([self.formatter stringFromDate:_datePicker.date]);
        [self removeFromSuperview];
    }
}

- (void)cancelAction:(UIButton *)btn {
    [self removeFromSuperview];
}

- (void)dateChange:(id)datePicker {
    
}

#pragma mark - setter、getter
- (void)setSelectDate:(NSString *)selectDate {
    [_datePicker setDate:[self.formatter dateFromString:selectDate] animated:YES];
}
- (NSDateFormatter *)formatter {
    if (_formatter) {
        return _formatter;
    }
    _formatter =[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    return _formatter;
    
}

//获取当前日期
+(NSString *)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//获取当前日期前一天
+(NSString *)getDayBeforeCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}


@end

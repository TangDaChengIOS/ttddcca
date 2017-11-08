//
//  RecordSelectToolView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RecordSelectToolView.h"

@interface RecordSelectToolView ()

@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * dateLab;
@property (nonatomic,strong) UIImageView * rightImageView;
@property (nonatomic,strong) UIButton * selectBtn;

@end

@implementation RecordSelectToolView

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, MAXWIDTH, 50);
        self.backgroundColor = kWhiteColor;
        //common_open_icon
        //profile_select_time_icon
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 17, 16, 16)];
        _leftImageView.image = KIMAGE(@"profile_select_time_icon");
        [self addSubview:_leftImageView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.maxX + 7, 17, 70, 16)];
        _titleLab.textColor = UIColorFromINTValue(141, 141, 141);
        _titleLab.font = kFont(13);
        _titleLab.text = @"交易类型";
        [self addSubview:_titleLab];
        
        _dateLab = [[UILabel alloc]initWithFrame:CGRectMake(MAXWIDTH /2 - 50 , 17, 100, 16)];
        _dateLab.textColor = UIColorFromINTValue(88, 88, 88);
        _dateLab.font = [UIFont boldSystemFontOfSize:13];
        _dateLab.text = @"05/06/2017";
        _dateLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLab];
        
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH - 66 -16, 17, 16, 16)];
        _rightImageView.image = KIMAGE(@"common_next_icon");
        _rightImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_rightImageView];
        
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(_titleLab.maxX + 10, 5, MAXWIDTH - _titleLab.maxX - 20, 40)];
        _selectBtn.backgroundColor = UIColorFromINTRGBA(255, 255, 255, 0.2);
        [self addSubview:_selectBtn];
    }
    return self;
}

@end
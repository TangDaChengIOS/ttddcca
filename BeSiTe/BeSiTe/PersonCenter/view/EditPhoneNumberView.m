//
//  EditPhoneNumberView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "EditPhoneNumberView.h"

@interface EditPhoneNumberView ()

@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UITextField * nameTF;

@end

@implementation EditPhoneNumberView

-(instancetype)init
{
    if (self = [super init]) {
        [self configSubViews];
    }
    return self;
}


-(void)configSubViews
{
    CGFloat whiteBack_W = MAXWIDTH - 100 * kPROPORTION;
   
    //中间的白色背景
    UIView * whiteBack = [[UIView alloc]initWithFrame:CGRectMake(50*kPROPORTION, (MAXHEIGHT - 285)/2, whiteBack_W, 285)];
    whiteBack.backgroundColor = kWhiteColor;
    whiteBack.layer.cornerRadius = 4;
    [self addSubview:whiteBack];
 
    //顶部的lab
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 100, 15)];
    _titleLab.text = @"验证手机号码";
    _titleLab.textColor = UIColorFromRGBValue(0x6a6a6a);
    _titleLab.font = kFont(15);
    [whiteBack addSubview:_titleLab];
  
    //手机号码输入
    UITextField * phoneTF = [self createTextFieldWithFrame:CGRectMake(16, _titleLab.maxY + 25, whiteBack_W - 32, 38)];
    phoneTF.placeholder = @"请输入手机号码";
    [whiteBack addSubview:phoneTF];
  
    //获取验证码按钮
    UIButton * getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(whiteBack_W - 16 - 90 * kPROPORTION, phoneTF.maxY + 12, 90 * kPROPORTION, 38)];
    getCodeBtn.layer.borderColor = UIColorFromINTValue(244, 144, 30).CGColor;
    getCodeBtn.layer.borderWidth = 1.0f;
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:UIColorFromINTValue(244, 144, 30) forState:UIControlStateNormal];
    getCodeBtn.layer.cornerRadius = 4.0f;
    getCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:getCodeBtn];
    
    //验证码输入框
    UITextField * codeTF = [self createTextFieldWithFrame:CGRectMake(16, phoneTF.maxY + 12, whiteBack_W - 36 - 90 * kPROPORTION, 38)];
    codeTF.placeholder = @"请输入验证码";
    [whiteBack addSubview:codeTF];
   
    //底部提醒字样lab
    UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(16, codeTF.maxY + 12,  whiteBack_W - 32, 15)];
    lab2.text = @"请在5分钟内输入验证码";
    lab2.textColor = UIColorFromINTValue(186, 186, 186);
    lab2.font = kFont(12);
    lab2.textAlignment = NSTextAlignmentCenter;
    [whiteBack addSubview:lab2];
    
    //提交
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, lab2.maxY + 12, whiteBack_W - 32, 40)];
    saveBtn.backgroundColor = UIColorFromINTValue(99, 162, 83);
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 4.0f;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:saveBtn];
   
    //取消
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, saveBtn.maxY + 10, whiteBack_W - 32, 40)];
    cancelBtn.layer.borderColor = UIColorFromINTValue(99, 162, 83).CGColor;
    cancelBtn.layer.borderWidth = 1.0f;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromINTValue(99, 162, 83) forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 4.0f;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:cancelBtn];
    
}
+(void)show{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    EditPhoneNumberView * view = [[EditPhoneNumberView alloc]init];
    [window addSubview:view];
}

-(void)saveBtnClick{
    
}


-(void)cancelBtnClick{
    
}


-(void)getCodeBtnClick{
    
}


@end

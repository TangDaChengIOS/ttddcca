//
//  EditPassWordView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "EditPassWordView.h"

@implementation EditPassWordView

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
    UIView * whiteBack = [[UIView alloc]initWithFrame:CGRectMake(50*kPROPORTION, (MAXHEIGHT - 300)/2, whiteBack_W, 300)];
    whiteBack.backgroundColor = kWhiteColor;
    whiteBack.layer.cornerRadius = 4;
    [self addSubview:whiteBack];
    
    //顶部的lab
    UILabel * _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 100, 15)];
    _titleLab.text = @"修改密码";
    _titleLab.textColor = UIColorFromRGBValue(0x6a6a6a);
    _titleLab.font = kFont(15);
    [whiteBack addSubview:_titleLab];
    
    UITextField * oldPwdTF = [self createTextFieldWithFrame:CGRectMake(16,_titleLab.maxY + 25, whiteBack_W - 32, 38)];
    oldPwdTF.placeholder = @"请输入原始密码";
    [whiteBack addSubview:oldPwdTF];
    
    UITextField * newPwdTF = [self createTextFieldWithFrame:CGRectMake(16,oldPwdTF.maxY + 6, whiteBack_W - 32, 38)];
    newPwdTF.placeholder = @"请输入新密码";
    newPwdTF.rightView = [self createButtonWithTag:1001];
    newPwdTF.rightViewMode = UITextFieldViewModeAlways;
    [whiteBack addSubview:newPwdTF];
    
    UITextField * newPwdTF2 = [self createTextFieldWithFrame:CGRectMake(16,newPwdTF.maxY + 6, whiteBack_W - 32, 38)];
    newPwdTF2.placeholder = @"请确认新密码";
    newPwdTF2.rightView = [self createButtonWithTag:1002];
    newPwdTF2.rightViewMode = UITextFieldViewModeAlways;
    [whiteBack addSubview:newPwdTF2];
   
    
    //提交
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, newPwdTF2.maxY + 10, whiteBack_W - 32, 40)];
    saveBtn.backgroundColor = UIColorFromINTValue(99, 162, 83);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
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
    EditPassWordView * view = [[EditPassWordView alloc]init];
    [window addSubview:view];
}

-(void)saveBtnClick{
    
}


-(void)cancelBtnClick{
    
}


-(void)getCodeBtnClick{
    
}
-(UIButton *)createButtonWithTag:(NSInteger)tag{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
//    button.backgroundColor = [UIColor redColor];
    button.contentMode = UIViewContentModeLeft;
    [button setImage:KIMAGE(@"profile_passworld_show_icon") forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(showOrHiddenPassword:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)showOrHiddenPassword:(UIButton *)button
{
    
}

@end

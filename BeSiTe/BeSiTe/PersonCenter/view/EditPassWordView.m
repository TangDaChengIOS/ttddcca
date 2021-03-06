//
//  EditPassWordView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "EditPassWordView.h"
#import "RSAEncryptor.h"

@interface EditPassWordView ()<UIAlertViewDelegate,UITextFieldDelegate>{

    UITextField * oldPwdTF;

    UITextField * newPwdTF;

    UITextField * newPwdTF2;
}

@end

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
    
    whiteBack.frame = CGRectMake(50*kPROPORTION, (MAXHEIGHT - 300)/2, whiteBack_W, 300);

    //中间的白色背景
//    UIView * whiteBack = [[UIView alloc]initWithFrame:CGRectMake(50*kPROPORTION, (MAXHEIGHT - 300)/2, whiteBack_W, 300)];
//    whiteBack.backgroundColor = kWhiteColor;
//    whiteBack.layer.cornerRadius = 4;
//    [self addSubview:whiteBack];
    
    //顶部的lab
    UILabel * _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 100, 15)];
    _titleLab.text = @"修改密码";
    _titleLab.textColor = UIColorFromRGBValue(0x6a6a6a);
    _titleLab.font = kFont(15);
    [whiteBack addSubview:_titleLab];
    
    oldPwdTF = [self createTextFieldWithFrame:CGRectMake(16,_titleLab.maxY + 25, whiteBack_W - 32, 38)];
    oldPwdTF.placeholder = @"请输入原始密码";
    oldPwdTF.secureTextEntry = YES;
    oldPwdTF.delegate = self;
    [whiteBack addSubview:oldPwdTF];
    
    newPwdTF = [self createTextFieldWithFrame:CGRectMake(16,oldPwdTF.maxY + 6, whiteBack_W - 32, 38)];
    newPwdTF.placeholder = @"请输入新密码";
    newPwdTF.rightView = [self createButtonWithTag:1001];
    newPwdTF.secureTextEntry = YES;
    newPwdTF.rightViewMode = UITextFieldViewModeAlways;
    newPwdTF.delegate = self;

    [whiteBack addSubview:newPwdTF];
    
    newPwdTF2 = [self createTextFieldWithFrame:CGRectMake(16,newPwdTF.maxY + 6, whiteBack_W - 32, 38)];
    newPwdTF2.placeholder = @"请确认新密码";
    newPwdTF2.rightView = [self createButtonWithTag:1002];
    newPwdTF2.rightViewMode = UITextFieldViewModeAlways;
    newPwdTF2.secureTextEntry = YES;
    newPwdTF2.delegate = self;

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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == oldPwdTF) {
        [newPwdTF becomeFirstResponder];
    }else if (textField == newPwdTF){
        [newPwdTF2 becomeFirstResponder];
    }else if (textField == newPwdTF2){
        [self endEditing:YES];
    }
    return YES;
}


+(void)showWithFinshBlock:(void(^)()) completeBlock
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    EditPassWordView * view = [[EditPassWordView alloc]init];
    view.completeBlock = completeBlock;
    [window addSubview:view];
}

-(void)saveBtnClick
{
    if (oldPwdTF.text.length <= 0 ) {
        TTAlert(@"请输入原始密码");
        return;
    }
    if (newPwdTF.text.length < 6 || newPwdTF.text.length > 10) {
        TTAlert(@"请输入正确长度的新密码(6~10位)");
        return;
    }
    if (newPwdTF2.text.length < 6 || newPwdTF2.text.length > 10) {
        TTAlert(@"请再次输入正确长度的新密码(6~10位)");
        return;
    }

    if ([newPwdTF.text isEqualToString:oldPwdTF.text]) {
        TTAlert(@"您输入的新密码与旧密码相同！");
        return;
    }
    
    if (![newPwdTF.text isEqualToString:newPwdTF2.text]) {
        TTAlert(@"两次输入的新密码不一致！");
        return;
    }
    [self endEditing:YES];

    NSString * oldPassWord = [RSAEncryptor encryptStringUseLocalFile:oldPwdTF.text];
    NSString * newPassWord = [RSAEncryptor encryptStringUseLocalFile:newPwdTF.text];
    NSDictionary * dict = @{@"oldPwd":oldPassWord,
                            @"newPwd":newPassWord};
    
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"modifyPwd" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];

        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self removeSelf];
    if (self.completeBlock) {
        self.completeBlock();
    }
}


-(void)cancelBtnClick{
    [self removeSelf];
}


-(UIButton *)createButtonWithTag:(NSInteger)tag{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
//    button.backgroundColor = [UIColor redColor];
    button.contentMode = UIViewContentModeLeft;
    [button setImage:KIMAGE(@"profile_passworld_show_icon") forState:UIControlStateNormal];
    [button setImage:KIMAGE(@"profile_passworld_hide_icon") forState:UIControlStateSelected];
    button.tag = tag;
    [button addTarget:self action:@selector(showOrHiddenPassword:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)showOrHiddenPassword:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.tag == 1001) {
        newPwdTF.secureTextEntry = !button.selected;
    }else{
        newPwdTF2.secureTextEntry = !button.selected;
    }
}

@end

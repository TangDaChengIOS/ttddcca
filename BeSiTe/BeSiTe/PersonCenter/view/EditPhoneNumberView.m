//
//  EditPhoneNumberView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "EditPhoneNumberView.h"

@interface EditPhoneNumberView ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField * phoneTF;
@property (nonatomic,strong) UITextField * codeTF;
@property (nonatomic,strong) UIButton * getCodeBtn;

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
   
    whiteBack.frame = CGRectMake(50*kPROPORTION, (MAXHEIGHT - 285)/2, whiteBack_W, 285);

    //中间的白色背景
//    UIView * whiteBack = [[UIView alloc]initWithFrame:CGRectMake(50*kPROPORTION, (MAXHEIGHT - 285)/2, whiteBack_W, 285)];
//    whiteBack.backgroundColor = kWhiteColor;
//    whiteBack.layer.cornerRadius = 4;
//    [self addSubview:whiteBack];
 
    //顶部的lab
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 100, 15)];
    _titleLab.text = @"验证手机号码";
    _titleLab.textColor = UIColorFromRGBValue(0x6a6a6a);
    _titleLab.font = kFont(15);
    [whiteBack addSubview:_titleLab];
  
    //手机号码输入
    _phoneTF = [self createTextFieldWithFrame:CGRectMake(16, _titleLab.maxY + 25, whiteBack_W - 32, 38)];
    _phoneTF.placeholder = @"请输入手机号码";
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.delegate = self;
    [whiteBack addSubview:_phoneTF];
  
    //获取验证码按钮
    _getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(whiteBack_W - 16 - 90 * kPROPORTION, _phoneTF.maxY + 12, 90 * kPROPORTION, 38)];
    _getCodeBtn.layer.borderColor = UIColorFromINTValue(244, 144, 30).CGColor;
    _getCodeBtn.layer.borderWidth = 1.0f;
    [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:UIColorFromINTValue(244, 144, 30) forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = kFont(14);
    _getCodeBtn.layer.cornerRadius = 4.0f;
    _getCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:_getCodeBtn];
    
    //验证码输入框
    _codeTF = [self createTextFieldWithFrame:CGRectMake(16, _phoneTF.maxY + 12, whiteBack_W - 36 - 90 * kPROPORTION, 38)];
    _codeTF.placeholder = @"请输入验证码";
    _codeTF.delegate = self;
    [whiteBack addSubview:_codeTF];
   
    //底部提醒字样lab
    UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(16, _codeTF.maxY + 12,  whiteBack_W - 32, 15)];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTF) {
        [self.codeTF becomeFirstResponder];
    }else if (textField == self.codeTF){
        [self endEditing:YES];
    }
    return YES;
}

+(void)showWithEditPhoneType:(EditPhoneNumberViewType)type withFinshBlock:(void(^)()) completeBlock
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    EditPhoneNumberView * view = [[EditPhoneNumberView alloc]init];
    view.editType = type;
    view.titleLab.text = type == EditPhoneNumberViewTypeEdit ? @"修改手机号码":@"验证手机号码";
    view.completeBlock = completeBlock;
    [window addSubview:view];
}

-(void)saveBtnClick{
    if (![ZZTextInput isValidateMobile:self.phoneTF.text]) {
        TTAlert(@"请输入正确的手机号码");
        return;
    }

    if ([self.phoneTF.text isEqualToString:[BSTSingle defaultSingle].user.mobile] && self.editType == EditPhoneNumberViewTypeEdit) {
        TTAlert(@"您输入的新手机号与原手机号码一致！");
        return;
    }
    
    if (self.codeTF.text.length <= 0) {
        TTAlert(@"请输入验证码");
        return;
    }
    [self endEditing:YES];
    if (self.editType == EditPhoneNumberViewTypeEdit) {
        [self changePhone];
    }else{
        [self verifyPhone];
    }
}

-(void)changePhone{
    NSDictionary * dict  = @{@"smsCode":self.codeTF.text,
                             @"mobile":self.phoneTF.text};
    kWeakSelf
    [RequestManager postWithPath:@"modifyMobile" params:dict success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        TTAlert(@"修改手机号成功");
        if (weak_self.completeBlock) {
            weak_self.completeBlock();
        }
        [weak_self removeSelf];
    } failure:^(NSError *error) {
        
    }];
}


-(void)verifyPhone{
    NSDictionary * dict  = @{@"type":@"1",
                             @"smsCode":self.codeTF.text,
                             @"validateParam":self.phoneTF.text};
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"verify" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];

        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        TTAlert(@"验证手机号成功");
        if (weak_self.completeBlock) {
            weak_self.completeBlock();
        }
        [weak_self removeSelf];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}



-(void)cancelBtnClick{
    [self removeSelf];
}


-(void)getCodeBtnClick{
    if (![ZZTextInput isValidateMobile:self.phoneTF.text]) {
        TTAlert(@"请输入正确的手机号码");
        return;
    }
    [self endEditing:YES];
    kWeakSelf
    NSDictionary * dict = @{@"mobile":self.phoneTF.text,
                            @"type":@"1"};
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"sendSmsCode" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        NSLog(@"%@",JSON);
        [weak_self.getCodeBtn countDownFromTime:60 completion:^(UIButton *countDownButton) {
            
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
    }];
}


@end

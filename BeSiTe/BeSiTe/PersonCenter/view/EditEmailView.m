//
//  EditEmailView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/1.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "EditEmailView.h"

@interface EditEmailView ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextField * emailTF;

@end

@implementation EditEmailView

-(instancetype)init
{
    if (self = [super init]) {
        [self configSubViews];
    }
    return self;
}


-(void)configSubViews
{
    CGFloat whiteBack_W = MAXWIDTH - 60 * kPROPORTION;
    whiteBack.frame = CGRectMake(30*kPROPORTION, (MAXHEIGHT - 254)/2, whiteBack_W, 254);
    
//    UIView * whiteBack = [[UIView alloc]initWithFrame:CGRectMake(30*kPROPORTION, (MAXHEIGHT - 254)/2, whiteBack_W, 254)];
//    whiteBack.backgroundColor = kWhiteColor;
//    whiteBack.layer.cornerRadius = 4;
//    [self addSubview:whiteBack];
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 100, 15)];
    lab.text = @"填写邮箱";
    lab.textColor = UIColorFromRGBValue(0x6a6a6a);
    lab.font = kFont(15);
    [whiteBack addSubview:lab];
    
    _emailTF = [self createTextFieldWithFrame:CGRectMake(16, lab.maxY + 25, whiteBack_W - 32, 38)];
    _emailTF.placeholder = @"请填写您的常用邮箱号码";
    _emailTF.textAlignment = NSTextAlignmentCenter;
    _emailTF.leftViewMode = UITextFieldViewModeNever;
    _emailTF.delegate = self;
    [whiteBack addSubview:_emailTF];
    
//    UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(16, _emailTF.maxY + 15,  whiteBack_W - 32, 15)];
//    lab2.text = @"此姓名将作为提款依据，不能修改";
//    lab2.textColor = UIColorFromRGBValue(0xcccccc);
//    lab2.font = kFont(12);
//    lab2.textAlignment = NSTextAlignmentCenter;
//    [whiteBack addSubview:lab2];
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, _emailTF.maxY + 40, whiteBack_W - 32, 40)];
    saveBtn.backgroundColor = UIColorFromINTValue(99, 162, 83);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 4.0f;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:saveBtn];
    
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
    if (textField == _emailTF){
        [self endEditing:YES];
    }
    return YES;
}

+(void)showWithFinshBlock:(void (^)())completeBlock{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    EditEmailView * view = [[EditEmailView alloc]init];
    view.completeBlock = completeBlock;
    [window addSubview:view];
}

-(void)saveBtnClick{
    if (self.emailTF.text.length <= 0) {
        TTAlert(@"请填写邮箱号码");
        return;
    }
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"completeUserInfo" params:@{@"email":self.emailTF.text} success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];

        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [BSTSingle defaultSingle].user.userName = weak_self.emailTF.text;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱号保存成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
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

@end

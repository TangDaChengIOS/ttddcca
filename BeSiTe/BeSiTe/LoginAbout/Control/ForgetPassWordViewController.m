//
//  ForgetPassWordViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "UIButton_withBadge.h"

@interface ForgetPassWordViewController ()

//公共模块
@property (weak, nonatomic) IBOutlet UIButton_withBadge *mailLookbtn;
@property (weak, nonatomic) IBOutlet UIButton_withBadge *phoneLookBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLab;

//邮件找回密码
@property (weak, nonatomic) IBOutlet UIView *mailLookSuperView;
@property (weak, nonatomic) IBOutlet UITextField *accoutTF_mail;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

//手机找回密码
@property (weak, nonatomic) IBOutlet UIView *phoneLookSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLookSuperViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *accountTF_phone;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *coedTF;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self refreshUI:YES];
 
}
#pragma mark -- 切换 邮件找回 / 手机找回
-(void)refreshUI:(BOOL)isLeft
{
    self.phoneLookBtn.backgroundColor = isLeft ?  UIColorFromINTValue(72, 190, 204) : kWhiteColor;
    [self.phoneLookBtn setTitleColor:( isLeft ? kWhiteColor : UIColorFromINTValue(33, 149, 167) ) forState:UIControlStateNormal];
    
    self.mailLookbtn.backgroundColor = isLeft ? kWhiteColor : UIColorFromINTValue(72, 190, 204)  ;
    [self.mailLookbtn setTitleColor:( isLeft ?  UIColorFromINTValue(33, 149, 167) :kWhiteColor ) forState:UIControlStateNormal];
    if (isLeft) {
        [self.mailLookbtn setImage:[KIMAGE(@"common_tab_select_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.mailLookbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self.phoneLookBtn setImage:nil forState:UIControlStateNormal];
        self.topLab.text = @"输入正确的账号及邮件地址，可前往邮箱设置新密码";
    }else{
        [self.phoneLookBtn setImage:[KIMAGE(@"common_tab_select_icon")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.phoneLookBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self.mailLookbtn setImage:nil forState:UIControlStateNormal];
        self.topLab.text = @"输入账号及手机号，获取验证码短信后可获得新密码";
    }
    _mailLookSuperView.hidden = !isLeft;
    _phoneLookSuperView.hidden = isLeft;
    _phoneLookSuperViewTopConstraint.constant =0;

}

- (IBAction)mailLookbtnClick:(id)sender {
    [self refreshUI:YES];

}
- (IBAction)phoneLookBtnClick:(id)sender {
    [self refreshUI:NO];

}
#pragma mark -- 提交邮件验证
- (IBAction)submitBtnClick:(id)sender {
    if (self.accoutTF_mail.text.length <= 0) {
        TTAlert(@"请输入账号");
        return;
    }
    if (![ZZTextInput isEmailAddress:self.emailTF.text]) {
        TTAlert(@"请输入正确的邮件地址");
        return;
    }
    
    NSDictionary * dict = @{@"email":self.emailTF.text,
                            @"loginName":self.accoutTF_mail.text};
    [RequestManager postWithPath:@"emailResetPwd" params:dict success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"提交成功";
        view.msgDetail = @"请前往邮箱设置新密码！";
        [view showInWindow];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 手机号找回，发送验证码
- (IBAction)sendCodeBtnClick:(id)sender {
    if (self.accountTF_phone.text.length <= 0) {
        TTAlert(@"请输入账号");
        return;
    }
    if (![ZZTextInput isValidateMobile:self.phoneTF.text]) {
        TTAlert(@"请输入正确的手机号码");
        return;
    }
    kWeakSelf
    NSDictionary * dict = @{@"mobile":self.phoneTF.text,
                            @"type":@"2",
                            @"loginName":self.accountTF_phone.text};
    [RequestManager postWithPath:@"sendSmsCode" params:dict success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        NSLog(@"%@",JSON);
        [weak_self.sendCodeBtn countDownFromTime:60 completion:^(UIButton *countDownButton) {
            
        }];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark -- 手机验证
- (IBAction)ensureBtnClick:(id)sender
{
    if (self.accountTF_phone.text.length <= 0) {
        TTAlert(@"请输入账号");
        return;
    }
    if (![ZZTextInput isValidateMobile:self.phoneTF.text]) {
        TTAlert(@"请输入正确的手机号码");
        return;
    }
    if (self.coedTF.text.length <= 0) {
        TTAlert(@"请输入验证码");
        return;
    }
    
    NSDictionary * dict = @{@"mobile":self.phoneTF.text,
                            @"smsCode":self.coedTF.text,
                            @"loginName":self.accountTF_phone.text};
    [RequestManager postWithPath:@"mobileResetPwd" params:dict success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"验证成功";
        view.msgDetail = @"您的新密码将会发送到手机，请查收。";
        [view showInWindow];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  RegisterPageOneViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/23.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RegisterPageOneViewController.h"
#import "RegisterPageTwoViewController.h"
#import "RSAEncryptor.h"
#import "UserModel.h"

@interface RegisterPageOneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *pwdSecBackView;
@property (weak, nonatomic) IBOutlet UITextField *pwdSecTF;
@property (weak, nonatomic) IBOutlet UILabel *NotTurePwdLab;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *scrollViewFirstChildView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterPageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

#pragma mark -- subViews
-(void)configSubViews
{
    self.isNeedHiddenNav = YES;
    self.view.backgroundColor = kWhiteColor;

    CGFloat cornerRadius = 13;
    self.firstBtn.backgroundColor = kWhiteColor;
    [self.firstBtn setTitleColor:UIColorFromINTValue(1, 145, 166) forState:UIControlStateNormal];
    self.firstBtn.layer.cornerRadius = cornerRadius;

    self.secBtn.layer.borderColor = UIColorFromINTValue(255, 255, 255).CGColor;
    self.secBtn.layer.cornerRadius = cornerRadius;
    self.secBtn.layer.borderWidth = 1;
    
    self.threeBtn.layer.borderColor = UIColorFromINTValue(255, 255, 255).CGColor;
    self.threeBtn.layer.cornerRadius = cornerRadius;
    self.threeBtn.layer.borderWidth = 1;
    
    self.nameTF.delegate = self;
    self.nameTF.returnKeyType = UIReturnKeyDefault;
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self;
    self.pwdSecTF.delegate = self;
    self.pwdTF.delegate = self;
    self.NotTurePwdLab.hidden = YES;

    self.getCodeBtn.layer.borderColor = UIColorFromINTValue(244, 144, 30).CGColor;
    self.getCodeBtn.layer.cornerRadius = 4;
    self.getCodeBtn.layer.borderWidth = 1;
    
    CGFloat height = self.agreeBtn.maxY + 100;
    self.scrollViewHeightConstraint.constant = height;
    self.scrollView.contentSize = CGSizeMake(MAXWIDTH, height);
    
    kWeakSelf
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weak_self.scrollViewFirstChildView endEditing:YES];
    }];
    [self.scrollViewFirstChildView addGestureRecognizer:tap];
}
#pragma mark -- TextFieldDeleGate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.nameTF && self.nameTF.text.length == 0) {
        self.nameTF.text = @"BC";
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.pwdSecTF) {
        self.pwdSecBackView.layer.borderColor = UIColorFromINTValue(205, 205, 205).CGColor;
        self.NotTurePwdLab.hidden = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.pwdSecTF) {
        if (![self.pwdTF.text isEqualToString:self.pwdSecTF.text]) {
            self.pwdSecBackView.layer.borderColor = UIColorFromINTValue(252, 25, 26).CGColor;
            self.NotTurePwdLab.hidden = NO;
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTF && range.location <2) {
        textField.text = @"BC";
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTF) {
        [self.phoneTF becomeFirstResponder];
        return YES;
    }else if (textField == self.phoneTF){
        [self.codeTF becomeFirstResponder];
        return YES;
    }else if (textField == self.codeTF){
        [self.pwdTF becomeFirstResponder];
        return YES;
    }else if (textField == self.pwdTF){
        [self.pwdSecTF becomeFirstResponder];
        return YES;
    }else if (textField == self.pwdSecTF){
        [self.view endEditing:YES];
        return YES;
    }
    return YES;
}
#pragma mark -- 按钮事件
- (IBAction)registerBtnDidClicked:(id)sender
{
    _registerBtn.enabled = NO;
    
    if (![ZZTextInput inputNumberOrLetters:self.nameTF.text]) {
        TTAlert(@"请输入以数字、字母、下划线组成的6-15位的账号");
        _registerBtn.enabled = YES;
        return;
    }
    if (![ZZTextInput isValidateMobile:self.phoneTF.text]) {
        TTAlert(@"请输入正确的手机号码");
        _registerBtn.enabled = YES;
        return;
    }
    if (self.codeTF.text.length <= 0) {
        TTAlert(@"请输入验证码");
        _registerBtn.enabled = YES;
        return;
    }
    if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 10) {
        TTAlert(@"请输入正确长度的密码(6~10位)");
        _registerBtn.enabled = YES;
        return;
    }
    
    if (self.pwdSecTF.text.length < 6 || self.pwdSecTF.text.length > 10) {
        TTAlert(@"请再次输入正确长度的密码(6~10位)");
        _registerBtn.enabled = YES;
        return;
    }
    if (![self.pwdTF.text isEqualToString:self.pwdSecTF.text]) {
        self.pwdSecBackView.layer.borderColor = UIColorFromINTValue(252, 25, 26).CGColor;
        self.NotTurePwdLab.hidden = NO;
        _registerBtn.enabled = YES;
        return;
    }
    if (!self.agreeBtn.selected) {
        TTAlert(@"请阅读并同意《贝斯特相关条款和隐私权政策》");
        _registerBtn.enabled = YES;
        return;
    }
    NSString * passWord = [RSAEncryptor encryptStringUseLocalFile:self.pwdTF.text];
    NSDictionary * dict = @{@"loginName":self.nameTF.text,
                            @"mobile":self.phoneTF.text,
                            @"password":passWord,
                            @"smsCode":self.codeTF.text};
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"register" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        weak_self.registerBtn.enabled = YES;
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        UserModel * user = [UserModel new];
        [user mj_setKeyValues:JSON];
        user.accountName = weak_self.nameTF.text;
        [BSTSingle defaultSingle].user = user;
        [UserModel saveLoginData:JSON andAccountName:weak_self.nameTF.text];

        [weak_self.navigationController pushViewController:[[RegisterPageTwoViewController alloc]initWithNibName:@"RegisterPageTwoViewController" bundle:nil] animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
        weak_self.registerBtn.enabled = YES;
    }];
}
#pragma mark -- 获取验证码
- (IBAction)getCodeBtnDidClicked:(id)sender
{
    if (![ZZTextInput isValidateMobile:self.phoneTF.text]) {
        TTAlert(@"请输入正确的手机号码");
        return;
    }
    kWeakSelf
    NSDictionary * dict = @{@"mobile":self.phoneTF.text,
                            @"type":@"1"};
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"sendSmsCode" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        NSLog(@"%@",JSON);
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [weak_self.getCodeBtn countDownFromTime:60 completion:^(UIButton *countDownButton) {
            
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
    }];
}

- (IBAction)agreeBtn:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}

- (IBAction)readAgree:(id)sender {
    WebDetailViewController * webVC = [WebDetailViewController quickCreateWithUrl:[BSTSingle defaultSingle].registerAgreementUrl];
    webVC.isNeedAgreeBtn = YES;
    kWeakSelf
    webVC.agreeBtnClickBlock = ^(){
        weak_self.agreeBtn.selected = YES;
    };
    [self pushVC:webVC];
}

- (IBAction)leftBarButtonItemClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

+(void)presentRegisterController{
    RegisterPageOneViewController * registerVC = [[RegisterPageOneViewController alloc]initWithNibName:@"RegisterPageOneViewController" bundle:nil];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:registerVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

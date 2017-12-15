//
//  LoginViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterPageOneViewController.h"
#import "UserModel.h"
#import "ForgetPassWordViewController.h"
#import "RSAEncryptor.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet ATNeedBorderView *nameBackView;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *pwdBackView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *findPWDBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
//    self.nameTF.text = @"BC7896";
//    self.pwdTF.text = @"qwerty";
}

- (IBAction)loginBtnDidClicked:(id)sender
{
    if (self.nameTF.text.length <= 0) {
        TTAlert(@"请输入用户名");
        return;
    }

    if (self.pwdTF.text.length <= 0) {
        TTAlert(@"请输入密码");
        return;
    }
    kWeakSelf
    NSString * passWord = [RSAEncryptor encryptStringUseLocalFile:self.pwdTF.text];
    
    NSDictionary * dict = @{@"loginName":self.nameTF.text,
                            @"password":passWord};
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager getWithPath:@"login" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        UserModel * model = [[UserModel alloc]init];
        [model mj_setKeyValues:JSON];
        model.accountName = weak_self.nameTF.text;
        [BSTSingle defaultSingle].user = model;
        [[NSNotificationCenter defaultCenter]postNotificationName:BSTLoginSuccessNotification object:nil];
        [weak_self.navigationController dismissViewControllerAnimated:YES completion:nil];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}
- (IBAction)registerDidClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftBarButtonItemClick) name:BSTRegisterSuccessNotification object:nil];
    RegisterPageOneViewController * registerVC = [[RegisterPageOneViewController alloc]initWithNibName:@"RegisterPageOneViewController" bundle:nil];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:registerVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- subViews
-(void)configSubViews
{
//    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    self.title = @"登录";
    
    if (self.navigationController.presentingViewController) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    }

    
    self.view.backgroundColor = kWhiteColor;

    self.findPWDBtn.layer.borderColor = UIColorFromINTValue(251, 72, 76).CGColor;
    self.findPWDBtn.layer.borderWidth = 1;
    
    self.registerBtn.layer.borderColor = UIColorFromINTValue(99, 161, 84).CGColor;
    self.registerBtn.layer.borderWidth = 1;
    self.loginBtn.layer.borderColor = [UIColor clearColor].CGColor;
}
- (IBAction)findPWDBtnClick:(id)sender {
    ForgetPassWordViewController * forgetVC = [[ForgetPassWordViewController alloc]initWithNibName:@"ForgetPassWordViewController" bundle:nil];
    [self pushVC:forgetVC];
}

-(void)leftBarButtonItemClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

+(void)presentLoginViewController{
    LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BSTRegisterSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

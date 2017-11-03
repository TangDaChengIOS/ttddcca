//
//  LoginViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterPageOneViewController.h"

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
}
- (IBAction)sendCodeBtnDidClicked:(id)sender {
}
- (IBAction)loginBtnDidClicked:(id)sender {
}
- (IBAction)registerDidClicked:(id)sender {
    RegisterPageOneViewController * menuVC = [[RegisterPageOneViewController alloc]initWithNibName:@"RegisterPageOneViewController" bundle:nil];
    menuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:menuVC animated:YES];

}

#pragma mark -- subViews
-(void)configSubViews
{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    self.view.backgroundColor = kWhiteColor;
    CGFloat cornerRadius = 4;

    self.findPWDBtn.layer.borderColor = UIColorFromINTValue(251, 72, 76).CGColor;
    self.findPWDBtn.layer.cornerRadius = cornerRadius;
    self.findPWDBtn.layer.borderWidth = 1;
    
    self.loginBtn.layer.cornerRadius = cornerRadius;
    
    self.registerBtn.layer.borderColor = UIColorFromINTValue(99, 161, 84).CGColor;
    self.registerBtn.layer.cornerRadius = cornerRadius;
    self.registerBtn.layer.borderWidth = 1;
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

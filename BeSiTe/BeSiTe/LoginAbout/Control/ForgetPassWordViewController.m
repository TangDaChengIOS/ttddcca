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
@property (weak, nonatomic) IBOutlet UIButton_withBadge *mailLookbtn;
@property (weak, nonatomic) IBOutlet UIButton_withBadge *phoneLookBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UIView *mailLookSuperView;
@property (weak, nonatomic) IBOutlet UIView *phoneLookSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLookSuperViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *accoutTF_mail;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
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
        
    }else{
        [self.phoneLookBtn setImage:[KIMAGE(@"common_tab_select_icon")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.phoneLookBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self.mailLookbtn setImage:nil forState:UIControlStateNormal];
        
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
- (IBAction)submitBtnClick:(id)sender {
}
- (IBAction)sendCodeBtnClick:(id)sender {
}
- (IBAction)ensureBtnClick:(id)sender {
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

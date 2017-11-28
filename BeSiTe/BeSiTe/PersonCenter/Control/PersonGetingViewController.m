//
//  PersonGetingViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/1.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonGetingViewController.h"
#import "ATTextField.h"
#import "BankSelectViewController.h"
#import "RSAEncryptor.h"

@interface PersonGetingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mainAccountLab;

@property (weak, nonatomic) IBOutlet ATTextField *accountTF;
@property (weak, nonatomic) IBOutlet ATTextField *pwdTF;

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;

@property (weak, nonatomic) IBOutlet ATTextField *moneyTF;
@property (weak, nonatomic) IBOutlet ATTextField *cardTF;
@property (weak, nonatomic) IBOutlet ATTextField *cardAdressTF;
@property (weak, nonatomic) IBOutlet UIButton *managerCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (nonatomic,copy) NSString * bankCode;
@end

@implementation PersonGetingViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat viewH = MAXHEIGHT - 35 - 64 - 66- 50;
    _contentViewHeightConstraint.constant = (self.managerCardBtn.maxY < viewH) ? viewH : self.managerCardBtn.maxY + 50;
    _submitBtn.layer.cornerRadius = _managerCardBtn.layer.cornerRadius = 4.0f;
    _pwdTF.secureTextEntry = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
}

- (IBAction)selectBankBtnClick:(id)sender {
    BankSelectViewController * selectVC = [[BankSelectViewController alloc]init];
    kWeakSelf
    selectVC.selectBankBlock = ^(BankModel * model){
        [weak_self.bankImageView setImageURL:[NSURL URLWithString:model.icon]];
        weak_self.bankNameLab.text = model.bankName;
        weak_self.bankCode = model.bankCode;
    };
    [self pushVC:selectVC];
}
- (IBAction)submitBtnClick:(id)sender
{
    if (self.accountTF.text.length <= 0) {
        TTAlert(@"请输入账户名称");
        return;
    }
    
    if (self.pwdTF.text.length <= 0) {
        TTAlert(@"请输入密码");
        return;
    }
    if (_bankCode.length <= 0) {
        TTAlert(@"请选择银行");
        return;
    }
    if (![ZZTextInput onlyInputTheNumber:self.moneyTF.text]) {
        TTAlert(@"请输入正确的取款金额");
        return;
    }
    if (self.cardTF.text.length <= 0) {
        TTAlert(@"请输入银行卡/折号");
        return;
    }
    kWeakSelf
    NSString * passWord = [RSAEncryptor encryptStringUseLocalFile:self.pwdTF.text];
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setValue:self.accountTF.text forKey:@"loginName"];
    [mDict setValue:passWord forKey:@"password"];
    [mDict setValue:_bankCode forKey:@"bankCode"];
    [mDict setValue:self.cardTF.text forKey:@"cardNo"];
    [mDict setValue:self.moneyTF.text forKey:@"amount"];
    
    if (self.cardAdressTF.text.length > 0) {
        [mDict setValue:self.cardAdressTF.text forKey:@"bankAddr"];
    }

    [RequestManager postWithPath:@"userWithdraw" params:mDict success:^(id JSON) {
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)managerCardBtnClick:(id)sender {
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

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
#import "BankManagerViewController.h"
#import "MyBankModel.h"

@interface PersonGetingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainAccountLab;//主账户余额

@property (weak, nonatomic) IBOutlet ATTextField *accountTF;//账号
@property (weak, nonatomic) IBOutlet ATTextField *pwdTF;//密码

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;//银行图标

@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;//银行名称

@property (weak, nonatomic) IBOutlet ATTextField *moneyTF;//取款金额
@property (weak, nonatomic) IBOutlet ATTextField *cardTF;//卡、折号
@property (weak, nonatomic) IBOutlet ATTextField *cardAdressTF;//开户行地址
@property (weak, nonatomic) IBOutlet UIButton *managerCardBtn;//管理银行卡按钮
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交按钮

@property (weak, nonatomic) IBOutlet UIView *contentView;//容器（scrollview的childView）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;//容器的高度约束

@property (nonatomic,copy) NSString * bankCode;//银行code

//@property (nonatomic,strong) NSMutableArray * myBankDataSource;//我的银行卡数据
@property (nonatomic,strong) NSMutableArray * bankDataSource;//银行数据

@end

@implementation PersonGetingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedRequestPersonBalance = YES;

    CGFloat viewH = MAXHEIGHT - 35 - 64 - 66- 50;
    _contentViewHeightConstraint.constant = (self.managerCardBtn.maxY < viewH) ? viewH : self.managerCardBtn.maxY + 50;
    _submitBtn.layer.cornerRadius = _managerCardBtn.layer.cornerRadius = 4.0f;
    _pwdTF.secureTextEntry = YES;
    
    _accountTF.text = [BSTSingle defaultSingle].user.accountName;
    _accountTF.delegate = self;
    _pwdTF.delegate = self;
    _moneyTF.delegate = self;
    _cardTF.delegate = self;
    _cardAdressTF.delegate = self;
    
    kWeakSelf
    UITapGestureRecognizer * whiteBackTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weak_self.view endEditing:YES];
    }];
    [self.contentView addGestureRecognizer:whiteBackTap];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _accountTF){
        [_pwdTF becomeFirstResponder];
    }else if (textField == _pwdTF){
        [self.view endEditing:YES];
    }else if (textField == _moneyTF){
        [_cardTF becomeFirstResponder];
    }else if (textField == _cardTF){
        [_cardAdressTF becomeFirstResponder];
    }else if (textField == _cardAdressTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestBankData];
}

-(void)refreshPersonBalance{
    self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

-(void)requestBankData
{
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"banks" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        weak_self.bankDataSource = [BankModel jsonToArray:JSON];
        [weak_self dealBankCodeAndIcons];
    } failure:^(NSError *error) {
            
    }];
}
-(void)dealBankCodeAndIcons{
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    for (BankModel  * model in self.bankDataSource) {
        [mDict setValue:model.icon forKey:model.bankCode];
    }
    [BSTSingle defaultSingle].bankCodeIcon = mDict;
}


- (IBAction)selectBankBtnClick:(id)sender {
    BankSelectViewController * selectVC = [[BankSelectViewController alloc]init];
    selectVC.isNeedMyBankData = YES;
    selectVC.currentUseBankTag = -1;
    kWeakSelf
    selectVC.selectBankBlock = ^(BankModel * model){
        [weak_self.bankImageView setImageURL:[NSURL URLWithString:model.icon]];
        weak_self.bankNameLab.text = model.bankName;
        weak_self.bankCode = model.bankCode;
    };
    selectVC.selectMyBankBlock = ^(MyBankModel * model){
        [weak_self.bankImageView setImageURL:[NSURL URLWithString:model.icon]];
        weak_self.bankNameLab.text = model.bankName;
        weak_self.bankCode = model.bankCode;
        weak_self.cardTF.text = model.cardNo;
        weak_self.cardAdressTF.text = model.bankAddr;
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
    if (![ZZTextInput onlyInputMoney:self.moneyTF.text]) {
        TTAlert(@"请输入正确的取款金额(最多两位小数)！");
        return;
    }
    if (![ZZTextInput onlyInputTheNumber:self.cardTF.text]) {
        TTAlert(@"请输入正确的银行卡/折号");
        return;
    }
    
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
    [MBProgressHUD showMessage:@"" toView:nil];
    kWeakSelf
    [RequestManager postWithPath:@"userWithdraw" params:mDict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [BSTSingle defaultSingle].user.userAmount = [JSON[@"balance"] floatValue];
        weak_self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
        TTAlert(@"取款申请提交成功！");
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}
- (IBAction)managerCardBtnClick:(id)sender {
    BankManagerViewController * bankManagerVC = [[BankManagerViewController alloc]initWithNibName:@"BankManagerViewController" bundle:nil];
    [self pushVC:bankManagerVC];
}

-(NSMutableArray *)bankDataSource
{
    if (!_bankDataSource) {
        _bankDataSource = [NSMutableArray array];
    }
    return _bankDataSource;
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

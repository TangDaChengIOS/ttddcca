//
//  QuickSavingViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "QuickSavingViewController.h"
#import "ZFBHelpViewController.h"

@interface QuickSavingViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLab;
@property (weak, nonatomic) IBOutlet UILabel *bankUserNameLab;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giverNameBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveNameTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giveMoneyBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *zfbHelpBtn;

@property (weak, nonatomic) IBOutlet ATNeedBorderView *giveNumberBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveNumberTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subMitBtnTopConstraint;
@end

@implementation QuickSavingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _giveNameTF.delegate = self;
    _giveMoneyTF.delegate = self;
    _giveNumberTF.delegate = self;
    
    self.navigationController.navigationBar.translucent = NO;
    if (_savingType == QuickSavingType_Bank) {
        self.title =  @"秒存 网银转账";
        self.zfbHelpBtn.hidden = YES;
        self.giveMoneyTF.placeholder = @"请填写金额";
    }else{
        self.title = @"秒存 支付宝";
        self.giveNumberBackView.hidden = YES;
        self.subMitBtnTopConstraint.constant -= 50;
        
    }
    [self requestReceivBankInfo];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _giveNameTF){
        [_giveMoneyTF becomeFirstResponder];
    }else if (textField == _giveMoneyTF){
        if (_savingType == QuickSavingType_Bank) {
            [_giveNumberTF becomeFirstResponder];
        }else{
            [self.view endEditing:YES];
        }
    }else if (textField == _giveNumberTF){
        [self.view endEditing:YES];
    }
    return YES;
}

-(void)requestReceivBankInfo
{
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:self.view];
    [RequestManager getWithPath:@"getReceivBankInfo" params:nil success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:weak_self.view];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        NSString * type = (weak_self.savingType == QuickSavingType_Bank ? @"1" :@"2");
        for (NSDictionary * dict in JSON) {
            if ([dict[@"type"] isEqualToString:type]) {
                weak_self.bankNameLab.text = dict[@"bankName"];
                weak_self.bankCardLab.text = dict[@"bankCode"];
                weak_self.bankUserNameLab.text = dict[@"acctName"];
            }
        }
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weak_self.view];
        if (error) {
            TTAlert(kNetError);
        }
    }];
}


- (IBAction)submitClick:(id)sender
{
    if (self.giveNameTF.text.length <= 0) {
        TTAlert(@"请输入汇款人姓名！");
        return;
    }
    if ( ![ZZTextInput onlyInputMoney:self.giveMoneyTF.text]) {
        TTAlert(@"请输入正确的汇款金额(最多两位小数)！");
        return;
    }
    if (self.giveNumberTF.text.length <= 0 && _savingType == QuickSavingType_Bank) {
        TTAlert(@"请输入汇款单号！");
        return;
    }
//    type	string	是	1:网银 2:支付宝
//    userName	string	是	汇款人姓名
//    amount	string	是	支付金额，单位：元
//    orderNo	string	否	单号，type为1时必填
//    isApplyDiscnt	string 	是	是否申请优惠，0：不申请优惠1：申请优惠
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setValue:(_savingType == QuickSavingType_Bank ? @"1" :@"2") forKey:@"type"];
    [mDict setValue:self.giveNameTF.text forKey:@"userName"];
    [mDict setValue:self.giveMoneyTF.text forKey:@"amount"];
    
    if (self.giveNumberTF.text.length > 0) {
        [mDict setValue:self.giveNumberTF.text forKey:@"orderNo"];
    }
    
    [mDict setValue:@"1" forKey:@"isApplyDiscnt"];
    
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"quickPay" params:mDict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec_TLD;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"存款成功";
        view.msgDetail = @"到账有一定延时请耐心等待...\n交易记录可查询进度";
        [view showInWindow];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
    }];
}
- (IBAction)copyBankCardClick:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (self.bankCardLab.text.length >0) {
        pboard.string = self.bankCardLab.text;
    }else{
        pboard.string = @"";
    }
    TTAlert(@"复制成功！");
}
- (IBAction)copyUserNameClick:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (self.bankUserNameLab.text.length >0) {
        pboard.string = self.bankUserNameLab.text;
    }else{
        pboard.string = @"";
    }
    TTAlert(@"复制成功！");
}
- (IBAction)helpClick:(id)sender {
    
    [self pushVC:[WebDetailViewController quickCreateWithUrl:[BSTSingle defaultSingle].remitUrl]];
}
- (IBAction)zfbHelpClick:(id)sender {
    [self pushVC:[[ZFBHelpViewController alloc] init]];
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

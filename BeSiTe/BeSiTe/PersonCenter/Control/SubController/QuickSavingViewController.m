//
//  QuickSavingViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "QuickSavingViewController.h"

@interface QuickSavingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLab;
@property (weak, nonatomic) IBOutlet UILabel *bankUserNameLab;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giverNameBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveNameTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giveMoneyBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveMoneyTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giveNumberBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveNumberTF;

@end

@implementation QuickSavingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if (_savingType == QuickSavingType_Bank) {
        self.title =  @"秒存 网银转账";
    }else{
        self.title = @"秒存 支付宝";
        self.giveNumberBackView.hidden = YES;
    }
    [self requestReceivBankInfo];
}

-(void)requestReceivBankInfo
{
    kWeakSelf
    [RequestManager getWithPath:@"getReceivBankInfo" params:nil success:^(id JSON) {
        NSString * type = (weak_self.savingType == QuickSavingType_Bank ? @"1" :@"2");
        for (NSDictionary * dict in JSON) {
            if ([dict[@"type"] isEqualToString:type]) {
                weak_self.bankNameLab.text = dict[@"bankName"];
                weak_self.bankCardLab.text = dict[@"bankNum"];
                weak_self.bankUserNameLab.text = dict[@"payeeName"];
            }
        }
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        
    }];
}


- (IBAction)submitClick:(id)sender
{
    if (self.giveNameTF.text.length <= 0) {
        TTAlert(@"请输入汇款人姓名！");
        return;
    }
    if (self.giveMoneyTF.text.length <= 0) {
        TTAlert(@"请输入汇款金额！");
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
        [mDict setValue:self.giveNumberTF forKey:@"orderNo"];
    }
    
    [mDict setValue:@"1" forKey:@"isApplyDiscnt"];

    [RequestManager postWithPath:@"quickPay" params:mDict success:^(id JSON) {
        
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec_TLD;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"存款成功";
        view.msgDetail = @"到账有一定延时请耐心等待...\n交易记录可查询进度";
        [view showInWindow];
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)copyBankCardClick:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.bankCardLab.text;
}
- (IBAction)copyUserNameClick:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.bankUserNameLab.text;
}
- (IBAction)helpClick:(id)sender {
    
    [self pushVC:[WebDetailViewController quickCreateWithUrl:@"http://172.104.54.176:8080/check_bank_number"]];
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

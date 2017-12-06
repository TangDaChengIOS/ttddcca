//
//  RegisterPageTwoViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/23.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RegisterPageTwoViewController.h"
#import "BankSelectViewController.h"
#import "ASBirthSelectSheet.h"
#import "ZZTextInput.h"

@interface RegisterPageTwoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewFirstChildView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *boomRightBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *qqTF;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UITextField *bankCardTF;
@property (weak, nonatomic) IBOutlet UITextField *bankAddrTF;

@end

@implementation RegisterPageTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma mark -- subViews
-(void)configSubViews
{
    self.isNeedHiddenNav = YES;
    self.view.backgroundColor = kWhiteColor;
    CGFloat height = self.boomRightBtn.maxY + 50;
    self.scrollViewHeightConstraint.constant = height;
    self.scrollView.contentSize = CGSizeMake(MAXWIDTH, height);
    
    CGFloat cornerRadius = 13;
    self.firstBtn.backgroundColor = kWhiteColor;
    [self.firstBtn setTitleColor:UIColorFromINTValue(1, 145, 166) forState:UIControlStateNormal];
    self.firstBtn.layer.cornerRadius = cornerRadius;
    
    self.secBtn.backgroundColor = kWhiteColor;
    [self.secBtn setTitleColor:UIColorFromINTValue(1, 145, 166) forState:UIControlStateNormal];
    self.secBtn.layer.cornerRadius = cornerRadius;
    
    self.threeBtn.layer.borderColor = UIColorFromINTValue(255, 255, 255).CGColor;
    self.threeBtn.layer.cornerRadius = cornerRadius;
    self.threeBtn.layer.borderWidth = 1;
    
}
#pragma mark -- 选择出生日期
- (IBAction)selectBirthDayClick:(id)sender {
    [self.view endEditing:YES];

    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.selectDate = self.birthdayTF.text.length > 0 ? self.birthdayTF.text : [ASBirthSelectSheet getCurrentDate];
    kWeakSelf
    datesheet.GetSelectDate = ^(NSString *dateStr) {
        weak_self.birthdayTF.text = dateStr;
    };
    [self.view addSubview:datesheet];
}
#pragma mark -- 选择银行
- (IBAction)selectBankClick:(id)sender {
    BankSelectViewController * vc = [[BankSelectViewController alloc]init];
    kWeakSelf
    vc.selectBankBlock = ^(BankModel * model){
        [weak_self.bankImageView setImageURL:[NSURL URLWithString:model.icon]];
        weak_self.bankNameLab.text = model.bankName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 返回
- (IBAction)back:(id)sender
{
    [self registerSuccessExit];
}
#pragma mark -- 完成注册
- (IBAction)finishRegistClick:(id)sender
{
    if (self.nameTF.text.length <= 0) {
        TTAlert(@"请输入姓名");
        return;
    }
    if (self.birthdayTF.text.length <= 0) {
        TTAlert(@"请选择出生日期");
        return;
    }
    if (self.emailTF.text.length <= 0) {
        TTAlert(@"请输入邮箱账号");
        return;
    }
    if (![ZZTextInput isEmailAddress:self.emailTF.text]) {
        TTAlert(@"请输入正确的邮箱账号");
        return;
    }
    
    if (self.qqTF.text.length <= 0) {
        TTAlert(@"请输入QQ号");
        return;
    }
//    if (self.bankNameLab.text.length <= 0) {
//        TTAlert(@"请选择银行");
//        return;
//    }
//    if (self.bankCardTF.text.length <= 0) {
//        TTAlert(@"请输入银行卡号或存折号");
//        return;
//    }
//    
//    if (self.bankAddrTF.text.length <= 0) {
//        TTAlert(@"请输入开户行地址");
//        return;
//    }
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setValue:self.nameTF.text forKey:@"userName"];
    [mDict setValue:self.birthdayTF.text forKey:@"birthday"];
    [mDict setValue:self.emailTF.text forKey:@"email"];
    [mDict setValue:self.qqTF.text forKey:@"qq"];
    if (self.bankNameLab.text.length > 0) {
        [mDict setValue:self.bankNameLab.text forKey:@"bankCode"];
    }
    if (self.bankCardTF.text.length > 0) {
        [mDict setValue:self.bankCardTF.text forKey:@"cardNo"];
    }
    if (self.bankAddrTF.text.length > 0) {
        [mDict setValue:self.bankAddrTF.text forKey:@"bankAddr"];
    }

    [RequestManager postWithPath:@"completeUserInfo" params:mDict success:^(id JSON ,BOOL isSuccess) {
        NSLog(@"%@",JSON);
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        kWeakSelf
        
        [weak_self finishRefreshUI];
        
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeShowTwoSel;
        view.isSuccessMsg = YES;
        view.msgTitle = @"注册成功";
        view.msgDetail = @"恭喜成为贝斯特会员！";
        view.leftBtnTitle = @"回到首页";
        view.rightBtnTitle = @"验证手机领18元礼金";
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.eventBlock = ^(EventType eventType){
            if (eventType == EventTypeLeftBtnClick) {
                [weak_self registerSuccessExit];
            }
            else{
                [weak_self registerSuccessExit];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ApplicationNeedVerifyPhoneNum" object:nil];
            }
        };
        [view showInWindow];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 跳过
- (IBAction)passBtnClick:(id)sender {
    [self registerSuccessExit];
}
-(void)registerSuccessExit{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:BSTRegisterSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:BSTLoginSuccessNotification object:nil];

}

#pragma mark -- 完成注册,刷新界面
-(void)finishRefreshUI{
    self.threeBtn.backgroundColor = kWhiteColor;
    [self.threeBtn setTitleColor:UIColorFromINTValue(1, 145, 166) forState:UIControlStateNormal];
    self.threeBtn.layer.cornerRadius = 13;

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

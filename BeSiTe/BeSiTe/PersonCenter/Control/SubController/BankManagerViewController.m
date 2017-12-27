//
//  BankManagerViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/28.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BankManagerViewController.h"
#import "ATTextField.h"
#import "BankSelectViewController.h"
#import "MyBankModel.h"

@interface BankManagerViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuBtn_left;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn_center;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn_right;
@property (weak, nonatomic) IBOutlet ATTextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet ATTextField *cardNumTF;
@property (weak, nonatomic) IBOutlet ATTextField *addressTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderButton *delBtn;

@property (nonatomic,strong) MyBankModel * model_left;
@property (nonatomic,strong) MyBankModel * model_center;
@property (nonatomic,strong) MyBankModel * model_right;

@property (nonatomic,assign) NSInteger selectItem;
@property (nonatomic,copy) NSString * selectBankCode;

@end

@implementation BankManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectItem = -1;
    self.title = @"管理银行卡";
    self.delBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.nameTF.delegate = self;
    self.cardNumTF.delegate = self;
    self.addressTF.delegate = self;
    [self dealDataFromDataSource];
}

#pragma mark -- textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTF) {
        [self.view endEditing:YES];
    }else if (textField == self.cardNumTF){
        [self.addressTF becomeFirstResponder];
    }else if (textField == self.addressTF){
        [self.view endEditing:YES];
    }
    return YES;
}

/**读取信息*/
-(void)dealDataFromDataSource
{
    for (MyBankModel * model in self.banksArr) {
        if ([model.tagId isEqualToString:@"0"]) {
            self.model_left = model;
            [self.menuBtn_left setTitle:model.tagName forState:UIControlStateNormal];
        }
        else if ([model.tagId isEqualToString:@"1"]) {
            self.model_center = model;
            [self.menuBtn_center setTitle:model.tagName forState:UIControlStateNormal];
        }
        else if ([model.tagId isEqualToString:@"2"]) {
            self.model_right = model;
            [self.menuBtn_right setTitle:model.tagName forState:UIControlStateNormal];
        }
    }
    self.selectItem = 0;
}

#pragma mark -- 选择银行
- (IBAction)selectBankClick:(id)sender {
    BankSelectViewController * selectVC = [[BankSelectViewController alloc]init];
    kWeakSelf
    selectVC.selectBankBlock = ^(BankModel * model){
        [weak_self.bankImageView setImageURL:[NSURL URLWithString:model.icon]];
        weak_self.bankNameLab.text = model.bankName;
        weak_self.selectBankCode = model.bankCode;
    };
    [self pushVC:selectVC];
}
#pragma mark -- 保存
- (IBAction)saveBtnClick:(id)sender
{
    if (self.nameTF.text.length <= 0 || self.nameTF.text.length > 6) {
        TTAlert(@"请输入正确长度的标签名(1~6个字符)");
        return;
    }
    if (!self.selectBankCode) {
        TTAlert(@"请选择银行");
        return;
    }
    if (![ZZTextInput onlyInputTheNumber:self.cardNumTF.text]) {
        TTAlert(@"请输入正确的银行卡/折号");
        return;
    }
    if (self.addressTF.text.length <= 0) {
        TTAlert(@"请输入开户行地址");
        return;
    }


    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setValue:[NSString stringWithFormat:@"%ld",_selectItem] forKey:@"tagId"];
    [mDict setValue:self.nameTF.text forKey:@"tagName"];
    
    [mDict setValue:_selectBankCode forKey:@"bankCode"];
    [mDict setValue:self.cardNumTF.text forKey:@"cardNo"];
    [mDict setValue:self.addressTF.text forKey:@"bankAddr"];
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"addUserBankInfo" params:mDict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        TTAlert(@"保存银行卡信息成功！");
        [weak_self resetDataAfterSave];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}

#pragma mark -- 保存成功后处理数据
-(void)resetDataAfterSave{
    if (_selectItem == 0) {
        [self.menuBtn_left setTitle:self.nameTF.text forState:UIControlStateNormal];
        if (!_model_left) {
            _model_left = [MyBankModel new];
        }
        [self resetModel:_model_left];
    }
    else if (_selectItem == 1) {
        [self.menuBtn_center setTitle:self.nameTF.text forState:UIControlStateNormal];
        if (!_model_center) {
            _model_center = [MyBankModel new];
        }
        [self resetModel:_model_center];
    }
    else if (_selectItem == 2) {
        [self.menuBtn_right setTitle:self.nameTF.text forState:UIControlStateNormal];
        if (!_model_right) {
            _model_right = [MyBankModel new];
        }
        [self resetModel:_model_right];
    }
}
#pragma mark -- 删除
- (IBAction)delBtnClick:(id)sender
{
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"deleteUserBankInfo" params:@{@"tagId":[NSString stringWithFormat:@"%ld",_selectItem]} success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        TTAlert(@"删除银行卡信息成功！");
        [weak_self resetDataAfterDelete];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}
#pragma mark -- 删除后清理数据
-(void)resetDataAfterDelete{
    if (_selectItem == 0) {
        _model_left = nil;
        [self.menuBtn_left setTitle:@"未添加" forState:UIControlStateNormal];
    }
    else if (_selectItem == 1) {
        _model_center = nil;
        [self.menuBtn_center setTitle:@"未添加" forState:UIControlStateNormal];
    }
    else if (_selectItem == 2) {
        _model_right = nil;
        [self.menuBtn_right setTitle:@"未添加" forState:UIControlStateNormal];
    }
    [self setDateWithModel:nil];
}
#pragma mark -- 将数据存储到模型中
-(void)resetModel:(MyBankModel *)model
{
    model.tagName = _nameTF.text;
    model.bankName = _bankNameLab.text;
    model.cardNo =  _cardNumTF.text;
    model.bankAddr = _addressTF.text;
    model.bankCode=   _selectBankCode;
    self.delBtn.hidden = NO;
}
#pragma mark -- 更新界面展示数据
-(void)setDateWithModel:(MyBankModel *)model
{
    if (model) {
        _nameTF.text = model.tagName;
        [_bankImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:nil];
        _bankNameLab.text = model.bankName;
        _cardNumTF.text = model.cardNo;
        _addressTF.text = model.bankAddr;
        _selectBankCode = model.bankCode;
        self.delBtn.hidden = NO;

//        self.delBtn.layer.borderColor = [UIColor redColor].CGColor;
//        [self.delBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        self.delBtn.enabled = YES;
    }
    else{
        _nameTF.text = @"";
        _bankImageView.image = nil;
        _bankNameLab.text = @"";
        _cardNumTF.text = @"";
        _addressTF.text = @"";
        _selectBankCode = @"";
        self.delBtn.hidden = YES;

//        self.delBtn.layer.borderColor = UIColorFromRGBValue(0xe1e1e1).CGColor;
//        [self.delBtn setTitleColor:UIColorFromRGBValue(0xe1e1e1) forState:UIControlStateNormal];
//        self.delBtn.enabled = NO;


    }
}

#pragma mark -- 切换菜单
- (IBAction)menuBtnLeftClick:(id)sender {
    self.selectItem = 0;
}

- (IBAction)menuBtnCenterClick:(id)sender {
    self.selectItem = 1;
}

- (IBAction)menuBtnRightClick:(id)sender {
    self.selectItem = 2;
}

-(void)setSelectItem:(NSInteger)selectItem
{
    if (selectItem == _selectItem) {
        return;
    }
    _selectItem = selectItem;
    if (selectItem == 0) {
        [self setDateWithModel:_model_left];
    }
    else if (selectItem == 1) {
        [self setDateWithModel:_model_center];
    }
    else if (selectItem == 2) {
        [self setDateWithModel:_model_right];
    }

    [self setButton:self.menuBtn_left selected:(selectItem == 0 ? YES : NO)];
    [self setButton:self.menuBtn_center selected:(selectItem == 1 ? YES : NO)];
    [self setButton:self.menuBtn_right selected:(selectItem == 2 ? YES : NO)];
}

-(void)setButton:(UIButton *)button selected:(BOOL)isSelected{
    button.backgroundColor = isSelected ? kWhiteColor : UIColorFromINTValue(72, 190, 203);
   
    [button setTitleColor:( isSelected ? UIColorFromINTValue(10, 143, 164) : UIColorFromINTValue(168, 234, 242)) forState:UIControlStateNormal];
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

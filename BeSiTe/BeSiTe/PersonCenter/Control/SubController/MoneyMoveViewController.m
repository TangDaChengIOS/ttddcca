//
//  MoneyMoveViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyMoveViewController.h"
#import "MoneyListTableViewCell.h"
#import "BalanceModel.h"
#import "GameCompanySelectViewController.h"

@interface MoneyMoveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *moveToGameBtn;//转入到游戏
@property (weak, nonatomic) IBOutlet UIButton *moveToMainBtn;//转出到主账户
@property (weak, nonatomic) IBOutlet UILabel *companyLab;//游戏平台Lab
@property (weak, nonatomic) IBOutlet UIButton *changeCompanyBtn;//选择游戏平台按钮（透明按钮，覆盖Lab）
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额输入框
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交按钮
@property (weak, nonatomic) IBOutlet UILabel *mainAccountLab;//主账户标签
@property (weak, nonatomic) IBOutlet UITableView *tableView;//底下列表

@property (nonatomic,strong) UIButton * titleViewBtn;//导航栏标题视图
@property (nonatomic,copy) NSString * selectCompanyCode;//选中的游戏平台code

@end

@implementation MoneyMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshUI:(_isMoveToGame ? YES : NO)];
    [self configSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}


-(void)reloadData
{
    if ([BSTSingle defaultSingle].user) {
        [_titleViewBtn setImage:KIMAGE_Ori([[BSTSingle defaultSingle].user getVipImageStr]) forState:UIControlStateNormal];
        [_titleViewBtn setTitle:[BSTSingle defaultSingle].user.accountName forState:UIControlStateNormal];
    }else{
        [_titleViewBtn setImage:nil forState:UIControlStateNormal];
        [_titleViewBtn setTitle:@"未登录" forState:UIControlStateNormal];
    }
    self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
    [self.tableView reloadData];
}


#pragma mark -- UITableViewDelegate / DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BSTSingle defaultSingle].gameCompanysBalanceArr.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMoneyListTableViewCellReuseID forIndexPath:indexPath];
    cell.cellTye = indexPath.row;
    if (indexPath.row == 0) {
        [cell setCell:@"游戏平台" money:@"余额(元)" whiteBack:(indexPath.row % 2)];
        
    }else{
        BalanceModel * model = [BSTSingle defaultSingle].gameCompanysBalanceArr[indexPath.row -1];
        [cell setCell:model.gamePlatformCode money:model.balance whiteBack:(indexPath.row % 2)];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 37 : 28;
}

#pragma mark -- UI配置
-(void)configSubViews
{
    _titleViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [_titleViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    self.navigationItem.titleView = _titleViewBtn;
    
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.borderColor = UIColorFromRGBValue(0xf3f3f3).CGColor;
    _tableView.layer.borderWidth = 1;
    [_tableView registerClass:[MoneyListTableViewCell class] forCellReuseIdentifier:kMoneyListTableViewCellReuseID];
    
}
#pragma mark -- 切换不同的转账方式
-(void)refreshUI:(BOOL)isLeft
{
    self.moveToMainBtn.backgroundColor = isLeft ?  UIColorFromINTValue(72, 190, 204) : kWhiteColor;
    [self.moveToMainBtn setTitleColor:( isLeft ? kWhiteColor : UIColorFromINTValue(33, 149, 167) ) forState:UIControlStateNormal];
    
    self.moveToGameBtn.backgroundColor = isLeft ? kWhiteColor : UIColorFromINTValue(72, 190, 204)  ;
    [self.moveToGameBtn setTitleColor:( isLeft ?  UIColorFromINTValue(33, 149, 167) :kWhiteColor ) forState:UIControlStateNormal];
    if (isLeft) {
        [self.moveToGameBtn setImage:[KIMAGE(@"common_tab_select_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.moveToGameBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [self.moveToMainBtn setImage:nil forState:UIControlStateNormal];

    }else{
        [self.moveToMainBtn setImage:[KIMAGE(@"common_tab_select_icon")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.moveToMainBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [self.moveToGameBtn setImage:nil forState:UIControlStateNormal];

    }
}

#pragma mark -- ButtonsEvents
- (IBAction)submitBtnClick:(id)sender
{
    if (!_selectCompanyCode) {
        TTAlert(@"请选择一个游戏平台");
        return;
    }
    if ( ![ZZTextInput onlyInputTheNumber:self.moneyTF.text]) {
        TTAlert(@"请输入正确的转账金额（金额不能为小数或负数）");
        return;
    }
    [self.view endEditing:YES];
    
    NSDictionary * dict = @{@"gamePlatformCode":_selectCompanyCode,
                            @"amount":self.moneyTF.text,
                            @"type":(_isMoveToGame ? @"1":@"2")};
    
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"acctTransfer" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        TTAlert(@"转账成功!");
        [BSTSingle defaultSingle].user.userAmount = [JSON[@"balance"] floatValue];
        NSDictionary * resultDict = JSON[@"gameBalance"][0];
        [[BSTSingle defaultSingle]updateGameCompany:resultDict[@"gamePlatformCode"] balance:resultDict[@"balance"]];
        [self reloadData];
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
    }];
}

- (IBAction)changeCompanyBtnClick:(id)sender
{
    GameCompanySelectViewController * selectVC = [[GameCompanySelectViewController alloc]init];
    kWeakSelf
    selectVC.finshSelectCompanyBlock = ^(GamesCompanyModel * model){
        weak_self.companyLab.text = model.companyName;
        weak_self.selectCompanyCode = model.companyCode;
    };
    [self pushVC:selectVC];
}

- (IBAction)moveToGameBtnClick:(id)sender {
    _isMoveToGame = YES;
    [self refreshUI:YES];
}
- (IBAction)moveToMainAccountClick:(id)sender {
    _isMoveToGame = NO;
    [self refreshUI:NO];
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

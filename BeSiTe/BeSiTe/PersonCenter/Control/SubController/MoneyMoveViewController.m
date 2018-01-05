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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic,strong) UIButton * titleViewBtn;//导航栏标题视图
@property (nonatomic,copy) NSString * selectCompanyCode;//选中的游戏平台code

@property (nonatomic,assign) NSInteger finishRequest;//完成请求数

@end

@implementation MoneyMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshUI:(_isMoveToGame ? YES : NO)];
    [self configSubViews];

    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
//        [weak_self getBalanceData];
        [weak_self getBalanceDataOneByOne];
    }];
    
    if ([BSTSingle defaultSingle].gameCompanysBalanceArr.count > 0) {
        [self.tableView reloadData];
        [self resetConstraint];
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark -- 挨个刷新平台的余额
-(void)getBalanceDataOneByOne
{
    _finishRequest = 0;
    [[BSTSingle defaultSingle].gameCompanysBalanceArr removeAllObjects];
    [self.tableView reloadData];
    [MBProgressHUD showMessage:@"" toView:self.view];
    kWeakSelf
    for (GamesCompanyModel * model in [BSTSingle defaultSingle].companysArray) {
        [RequestManager getWithPath:@"getGameBalance" params:@{@"gamePlatformCode":model.companyCode} success:^(id JSON ,BOOL isSuccess) {
            weak_self.finishRequest ++;
            if (!isSuccess) {
                TTAlert(JSON);
                return ;
            }
            if ([[JSON class]isSubclassOfClass:[NSArray class]]) {
                NSDictionary * dict = JSON[0];
                BalanceModel * model = [[BalanceModel alloc]init];
                [model mj_setKeyValues:dict];
                [[BSTSingle defaultSingle].gameCompanysBalanceArr addObject:model];
                [weak_self.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            weak_self.finishRequest ++;
        }];
    }
}

-(void)setFinishRequest:(NSInteger)finishRequest
{
    _finishRequest = finishRequest;
    if (_finishRequest == [BSTSingle defaultSingle].companysArray.count && _finishRequest > 0) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self resetConstraint];
    }
}
#pragma mark -- 获取所有的平台余额
-(void)getBalanceData
{
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:self.view];
    [RequestManager getWithPath:@"getGameBalance" params:nil success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        [weak_self.tableView.mj_header endRefreshing];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [BSTSingle defaultSingle].gameCompanysBalanceArr = [BalanceModel jsonToArray:JSON];
        [weak_self.tableView reloadData];
        [weak_self resetConstraint];
        
    } failure:^(NSError *error) {
        [weak_self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark -- 刷新单个平台的余额
-(void)getBalanceDataWithCompany:(NSString *)company
{
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:self.view];
    [RequestManager getWithPath:@"getGameBalance" params:@{@"gamePlatformCode":company} success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        if ([[JSON class]isSubclassOfClass:[NSArray class]]) {
            NSDictionary * dict = JSON[0];
            BalanceModel * model = [[BalanceModel alloc]init];
            [model mj_setKeyValues:dict];
            [[BSTSingle defaultSingle]updateGameCompany:model.gamePlatformCode balance:model.balance];
            if ([model.balance componentsSeparatedByString:@"失败"].count > 1) {
                TTAlert(@"刷新数据失败，请稍后再试！");
            }
        }
        [weak_self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
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
}


#pragma mark -- UITableViewDelegate / DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([BSTSingle defaultSingle].gameCompanysBalanceArr.count == 0) {
        return 0;
    }
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
        kWeakSelf
        cell.retryBlock = ^(NSString * gameCompanyCode){
            [weak_self getBalanceDataWithCompany:gameCompanyCode];
        };
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

-(void)resetConstraint
{
    CGFloat needHeight = 37 + 28 * [BSTSingle defaultSingle].gameCompanysBalanceArr.count;
    if (self.tableView.mj_y + needHeight + 30 < MAXHEIGHT - 64) {
        self.tableViewHeightConstraint.constant = needHeight;
//        self.tableView.scrollEnabled = NO;
    }
    else{
        self.tableViewHeightConstraint.constant = MAXHEIGHT - 64 - 30 -self.tableView.mj_y;
//        self.tableView.scrollEnabled = YES;
    }
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
    if ( ![ZZTextInput onlyInputMoney:self.moneyTF.text]) {
        TTAlert(@"请输入正确的转账金额(最多两位小数)！");
        return;
    }
    [self.view endEditing:YES];
    
    NSDictionary * dict = @{@"gamePlatformCode":_selectCompanyCode,
                            @"amount":self.moneyTF.text,
                            @"type":(_isMoveToGame ? @"1":@"2")};
    
    [MBProgressHUD showMessage:@"" toView:nil];
    kWeakSelf
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
        [weak_self reloadData];
        [weak_self.tableView reloadData];
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
        if (error) {
            TTAlert(kNetError);
        }
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

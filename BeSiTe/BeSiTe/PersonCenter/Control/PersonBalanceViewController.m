//
//  PersonBalanceViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonBalanceViewController.h"
#import "MoneyListTableViewCell.h"
#import "MoneyMoveViewController.h"
#import "BalanceModel.h"

@interface PersonBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *aplyMoneyBtn;//申请救援金
@property (weak, nonatomic) IBOutlet UIButton *turnInBtn;//转入
@property (weak, nonatomic) IBOutlet UIButton *turnOutBtn;//转出
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;//tableview高度约束
@property (nonatomic,assign) NSInteger finishRequest;//完成请求数
@end

@implementation PersonBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configSubViews];
    [self resetConstraint];
    
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weak_self getBalanceData];
        [weak_self getBalanceDataOneByOne];
        [weak_self requestPersonBalance];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)refreshPersonBalance{
    self.totalMoneyLab.attributedText = [UserModel getTotalMoneyAttributeString];
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


-(void)resetConstraint
{
//    CGFloat needHeight = 37 + 28 * [BSTSingle defaultSingle].gameCompanysBalanceArr.count;
    CGFloat needHeight = 37 + 28 * [BSTSingle defaultSingle].companysArray.count;

    CGFloat maxH = MAXHEIGHT - 64 - 49 - 66 - 100;
    if (self.tableView.mj_y + needHeight + 10 < maxH ) {
        self.tableViewHeightConstraint.constant = needHeight;
//        self.tableView.scrollEnabled = NO;
    }
    else{
        self.tableViewHeightConstraint.constant = maxH - 10 -self.tableView.mj_y;
//        self.tableView.scrollEnabled = YES;
    }
}

-(void)configSubViews{
    self.view.backgroundColor = kWhiteColor;
    _aplyMoneyBtn.backgroundColor = UIColorFromINTValue(251, 138, 113);

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.borderColor = UIColorFromRGBValue(0xf3f3f3).CGColor;
    _tableView.layer.borderWidth = 1;
    [_tableView registerClass:[MoneyListTableViewCell class] forCellReuseIdentifier:kMoneyListTableViewCellReuseID];
    
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

#pragma mark -- setTotalMoney
-(void)setTotalMoney:(CGFloat)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@",###.00"];
    NSLog(@"%@",[NSNumber numberWithFloat:money]);
    NSString *convertNumber = [formatter stringFromNumber:[NSNumber numberWithDouble:money]];
    
    NSMutableAttributedString * mAtStr = [[NSMutableAttributedString alloc]initWithString:@"主账户余额 " attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:UIColorFromINTValue(124, 124, 124)}];
    NSAttributedString * atStr = [[NSAttributedString alloc]initWithString:convertNumber attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:UIColorFromINTValue(24, 119, 1)}];
    [mAtStr appendAttributedString:atStr];
    self.totalMoneyLab.attributedText = mAtStr;
}


#pragma mark -- ButtonEvents
- (IBAction)aplyBtnClick:(id)sender
{
    [MBProgressHUD showMessage:@"" toView:nil];
    
    [RequestManager postWithPath:@"applyFund" params:nil success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD  hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"恭喜";
        view.msgDetail = @"申请救援金成功！";
        [view showInWindow];
    } failure:^(NSError *error) {
        [MBProgressHUD  hideHUDForView:nil];
    }];
}

- (IBAction)turnInBtnClick:(id)sender {
    MoneyMoveViewController * moneyMoveVC = [[MoneyMoveViewController alloc]initWithNibName:@"MoneyMoveViewController" bundle:nil];
    moneyMoveVC.isMoveToGame = YES;
    [self pushVC:moneyMoveVC];
}
- (IBAction)turnOutBtnClick:(id)sender {
    MoneyMoveViewController * moneyMoveVC = [[MoneyMoveViewController alloc]initWithNibName:@"MoneyMoveViewController" bundle:nil];
    moneyMoveVC.isMoveToGame = NO;
    [self pushVC:moneyMoveVC];
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

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
@property (weak, nonatomic) IBOutlet UIButton *aplyMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *turnInBtn;
@property (weak, nonatomic) IBOutlet UIButton *turnOutBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation PersonBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.totalMoneyLab.attributedText = [UserModel getTotalMoneyAttributeString];
    [self getBalanceData];

    [self.tableView reloadData];
}

-(void)getBalanceData
{
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager getWithPath:@"getGameBalance" params:nil success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
       [BSTSingle defaultSingle].gameCompanysBalanceArr = [BalanceModel jsonToArray:JSON];
        [weak_self.tableView reloadData];
        [weak_self resetConstraint];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}


-(void)resetConstraint
{
    CGFloat needHeight = 37 + 28 * [BSTSingle defaultSingle].gameCompanysBalanceArr.count;
    if (self.tableView.mj_y + needHeight + 10 < self.turnInBtn.mj_y) {
        self.tableViewHeightConstraint.constant = needHeight;
        self.tableView.scrollEnabled = NO;
    }
    else{
        self.tableViewHeightConstraint.constant = self.turnInBtn.mj_y - 10 -self.tableView.mj_y;
        self.tableView.scrollEnabled = YES;
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

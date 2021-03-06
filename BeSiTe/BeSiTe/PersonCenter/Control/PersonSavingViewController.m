//
//  PersonSavingViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/29.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonSavingViewController.h"
#import "PersonSavingTableViewCell.h"
#import "QuickSavingViewController.h"
#import "OnlineSavingViewController.h"

@interface PersonSavingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonSavingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedRequestPersonBalance = YES;

    [self configSubViews];
}

-(void)refreshPersonBalance{
    self.totalMoneyLab.attributedText = [UserModel getTotalMoneyAttributeString];
}

-(void)configSubViews
{
    self.view.backgroundColor = kWhiteColor;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kWhiteColor;
    [_tableView registerClass:[PersonSavingTableViewCell class] forCellReuseIdentifier:kPersonSavingTableViewCellReuseID];
    
}
#pragma mark -- UITableViewDelegate / DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonSavingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kPersonSavingTableViewCellReuseID forIndexPath:indexPath];
    cell.cellType = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 1) {
        QuickSavingViewController * quickSavingVC = [[QuickSavingViewController alloc]initWithNibName:@"QuickSavingViewController" bundle:nil];
        quickSavingVC.savingType = (indexPath.row == 0 ? QuickSavingType_Bank : QuickSavingType_ZFB);
        [self pushVC:quickSavingVC];
    }else{
        OnlineSavingViewController * onlineVC = [[OnlineSavingViewController alloc]init];
        [self pushVC:onlineVC];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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

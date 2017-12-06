//
//  BankSelectViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/6.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BankSelectViewController.h"
#import "MyBankModel.h"

@interface BankSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation BankSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    if (self.myBankDataSource.count == 0) {
        self.isHaveOtherData = NO;
    }
    [self requestData];
}


-(void)requestData{
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"banks" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        weak_self.dataSource = [BankModel jsonToArray:JSON];
        [weak_self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- tableView delegate/dataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isHaveOtherData && indexPath.section == 0) {
        MyBankModel * model = self.myBankDataSource[indexPath.row];
        if (self.selectMyBankBlock) {
            self.selectMyBankBlock(model);
        }
    }else{
        BankModel * model = self.dataSource[indexPath.row];
        if (self.selectBankBlock) {
            self.selectBankBlock(model);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isHaveOtherData ? 2 : 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHaveOtherData && section == 0) {
        return   self.myBankDataSource.count ;
    }

    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kBankTableViewCellReuseID forIndexPath:indexPath];
    if (_isHaveOtherData && indexPath.section == 0) {
        [cell setMyBankCellWithModel:self.myBankDataSource[indexPath.row]];
    }else{
        [cell setCellWithModel:self.dataSource[indexPath.row]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isHaveOtherData) {
        UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"bankViewSecitonHeaderID"];
        header.contentView.backgroundColor = UIColorFromINTValue(230, 230, 230);
        if (header.contentView.subviews.count == 0 && section == 0) {
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, MAXWIDTH, 14)];
            lab.textColor = UIColorFromINTValue(145, 145, 145);
            lab.font = kFont(12);
            lab.text = @"已添加的银行卡";
            lab.textAlignment = NSTextAlignmentCenter;
            [header.contentView addSubview:lab];
        }
        else{
            [header.contentView removeAllSubviews];
        }
        return header;
    }
    return nil;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isHaveOtherData) {
        return section == 0 ? 22 : 6;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;
}

#pragma mark -- 配置页面
-(void)configSubViews{
    self.title = @"选择银行卡";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT - 64) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerNib:[UINib nibWithNibName:@"BankTableViewCell" bundle:nil] forCellReuseIdentifier:kBankTableViewCellReuseID];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"bankViewSecitonHeaderID"];
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MoneyRecord_ZZ_ViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyRecord_ZZ_ViewController.h"

@interface MoneyRecord_ZZ_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RecordTableViewCell * headerView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) BSTNoDataView * noDataView;

@end

@implementation MoneyRecord_ZZ_ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self requestDataForZhuanZhang];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weak_self.page += 1;
        [weak_self requestDataForZhuanZhang];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(NSDictionary *)para{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[BSTSingle defaultSingle].moneyRecordSearchPara];
    [dict setValue:@(self.page) forKey:@"pageNo"];
    [dict setValue:@(20) forKey:@"pageSize"];
    return dict;
}

#pragma mark -- 请求转账数据
-(void)requestDataForZhuanZhang
{
    kWeakSelf
    [RequestManager getWithPath:@"getUserTransfersInfos" params:[self para] success:^(id JSON ,BOOL isSuccess) {
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
        NSLog(@"%@",JSON);
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        if (weak_self.page == 1) {
            [weak_self.dataSource removeAllObjects];
        }
        [weak_self.dataSource addObjectsFromArray: [MoneyRecordModel jsonToArray:JSON[@"data"]]];
        [weak_self.tableView reloadData];
        if ([JSON[@"hasNext"] integerValue] == 0) {
            [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (weak_self.dataSource.count == 0) {
            [weak_self.tableView addSubview:weak_self.noDataView];
        }else{
            [weak_self.noDataView removeFromSuperview];
        }
        _page = [JSON[@"currentPage"] integerValue];
    } failure:^(NSError *error) {
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView delegate/dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCellReuseID forIndexPath:indexPath];
    [cell setCellWithModel:self.dataSource[indexPath.row] andCellType:RecordCellType_ZhuanZhang];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ShowRecordDetailView showWithModel:self.dataSource[indexPath.row] andRecordType:RecordCellType_ZhuanZhang];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(void)configSubViews{
    _headerView = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView.cellType = RecordDetailControlType_ZhuanZhang;
    [_headerView setTopCellWithVCType:RecordDetailControlType_ZhuanZhang];
    [self.view addSubview:_headerView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 28, MAXWIDTH, MAXHEIGHT - 64 -28 - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordTableViewCellReuseID];
    
    [self.view addSubview:_tableView];
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(BSTNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[BSTNoDataView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.isMsg = NO;
    }
    return _noDataView;
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

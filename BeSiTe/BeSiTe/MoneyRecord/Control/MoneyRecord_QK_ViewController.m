//
//  MoneyRecord_QK_ViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyRecord_QK_ViewController.h"
#import "MoneyRecordHomeViewController.h"

@interface MoneyRecord_QK_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RecordTableViewCell * headerView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) BSTNoDataView * noDataView;

@end

@implementation MoneyRecord_QK_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self requestDataForQuKuan];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weak_self.page += 1;
        [weak_self requestDataForQuKuan];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MoneyRecordHomeViewController * homeVC = (MoneyRecordHomeViewController *)self.magicController;
    if (homeVC.selectPageIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

-(NSDictionary *)para{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[BSTSingle defaultSingle].moneyRecordSearchPara];
    [dict setValue:@(self.page) forKey:@"pageNo"];
    [dict setValue:@(20) forKey:@"pageSize"];
    return dict;
}


#pragma mark -- 请求取款数据
-(void)requestDataForQuKuan{
    kWeakSelf
    [RequestManager getWithPath:@"getUserWithdrawInfos" params:[self para] success:^(id JSON ,BOOL isSuccess) {
        NSLog(@"%@",JSON);
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];

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
    [cell setCellWithModel:self.dataSource[indexPath.row] andCellType:RecordCellType_QuKuan];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ShowRecordDetailView showWithModel:self.dataSource[indexPath.row] andRecordType:RecordCellType_QuKuan];
}

-(void)configSubViews{
    _headerView = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView.cellType = RecordCellType_QuKuan;
    [_headerView setTopCellWithVCType:RecordDetailControlType_QuKuan];
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

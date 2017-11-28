//
//  JiFenDetailViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/31.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "JiFenDetailViewController.h"
#import "RecordTableViewCell.h"

@interface JiFenDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RecordTableViewCell * headerView_top;
@property (nonatomic,strong) RecordTableViewCell * headerView_boom;

@property (nonatomic,strong) UITableView * tableView_top;
@property (nonatomic,strong) UITableView * tableView_boom;

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSMutableArray * dataSource_boom;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger page_boom;

@end

@implementation JiFenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    
    kWeakSelf
    self.tableView_top.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self requestDataForDuiHuan];
    }];
    
    self.tableView_top.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        weak_self.page += 1;
        [weak_self requestDataForDuiHuan];
    }];
    
    self.tableView_boom.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        weak_self.page_boom = 1;
        [weak_self requestDataForHuoQu];
    }];
    
    self.tableView_boom.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        weak_self.page_boom += 1;
        [weak_self requestDataForHuoQu];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView_top.mj_header beginRefreshing];
    [self.tableView_boom.mj_header beginRefreshing];

}

-(NSDictionary *)para{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[BSTSingle defaultSingle].moneyRecordSearchPara];
    [dict setValue:@(self.page) forKey:@"pageNo"];
    [dict setValue:@(20) forKey:@"pageSize"];
    return dict;
}


#pragma mark -- 请求取款数据
-(void)requestDataForDuiHuan{
    [RequestManager getWithPath:@"getUserScoreExchangeInfos" params:[self para] success:^(id JSON) {
        NSLog(@"%@",JSON);
        [self.tableView_top.mj_header endRefreshing];
        
        self.dataSource = [MoneyRecordModel jsonToArray:JSON[@"data"]];
        [self.tableView_top reloadData];
        if ([JSON[@"hasNext"] integerValue] == 0) {
            [self.tableView_top.mj_footer endRefreshingWithNoMoreData];
        }
        _page = [JSON[@"currentPage"] integerValue];
    } failure:^(NSError *error) {
        
    }];
}

-(NSDictionary *)para_boom{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[BSTSingle defaultSingle].moneyRecordSearchPara];
    [dict setValue:@(self.page_boom) forKey:@"pageNo"];
    [dict setValue:@(20) forKey:@"pageSize"];
    return dict;
}


#pragma mark -- 请求取款数据
-(void)requestDataForHuoQu{
    [RequestManager getWithPath:@"getUserGainScoreInfos" params:[self para_boom] success:^(id JSON) {
        NSLog(@"%@",JSON);
        [self.tableView_boom.mj_header endRefreshing];
        
        self.dataSource_boom = [MoneyRecordModel jsonToArray:JSON[@"data"]];
        [self.tableView_boom reloadData];
        if ([JSON[@"hasNext"] integerValue] == 0) {
            [self.tableView_boom.mj_footer endRefreshingWithNoMoreData];
        }
        _page_boom = [JSON[@"currentPage"] integerValue];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- tableView delegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView_top) {
        return self.dataSource.count;
    }
    else{
        return self.dataSource_boom.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCellReuseID forIndexPath:indexPath];
    
    if (tableView == self.tableView_top) {
        [cell setCellWithModel:self.dataSource[indexPath.row] andCellType:RecordCellType_JiFenTop];
    }
    else{
        [cell setCellWithModel:self.dataSource_boom[indexPath.row] andCellType:RecordCellType_JiFenBoom];
    }

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


-(void)configSubViews
{
    CGFloat tableViewH  = (MAXHEIGHT - 64 - 50 - (24 + 28)*2 ) /2;
    
//上部分标题
    UILabel * topLab = [self createLabWithFrame:CGRectMake(0, 0, MAXWIDTH, 24) andTitle:@"兑换记录"];
    [self.view addSubview:topLab];
    
//上部分列表头
    _headerView_top = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView_top.top = 24;
    _headerView_top.cellType = RecordCellType_CunKuan;
    [_headerView_top setTopCellWithVCType:RecordDetailControlType_JiFenTop];
    [self.view addSubview:_headerView_top];
    
//上部分tableview
    _tableView_top = [[UITableView alloc]initWithFrame:CGRectMake(0, 52, MAXWIDTH, tableViewH) style:UITableViewStyleGrouped];
    _tableView_top.delegate = self;
    _tableView_top.dataSource = self;
    [_tableView_top registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordTableViewCellReuseID];
    [self.view addSubview:_tableView_top];
    
//下部分标题
    UILabel * boomLab = [self createLabWithFrame:CGRectMake(0, _tableView_top.maxY, MAXWIDTH, 24) andTitle:@"获取记录"];
    [self.view addSubview:boomLab];
    
//下部分列表头
    _headerView_boom = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView_boom.top = boomLab.maxY;
    _headerView_boom.cellType = RecordCellType_YouHui;
    [_headerView_boom setTopCellWithVCType:RecordDetailControlType_JiFenBoom];
    [self.view addSubview:_headerView_boom];

//下部分tableview
    _tableView_boom = [[UITableView alloc]initWithFrame:CGRectMake(0, boomLab.maxY + 28, MAXWIDTH, tableViewH) style:UITableViewStyleGrouped];
    _tableView_boom.delegate = self;
    _tableView_boom.dataSource = self;
    [_tableView_boom registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordTableViewCellReuseID];
    [self.view addSubview:_tableView_boom];
}
//共用方法创建lab
-(UILabel *)createLabWithFrame:(CGRect)frame andTitle:(NSString *)title{
    UILabel * lable = [[UILabel alloc]initWithFrame:frame];
    lable.backgroundColor = UIColorFromINTValue(192, 238, 244);
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = kFont(12);
    lable.textColor = UIColorFromINTValue(52, 152, 165);
    lable.text = title;
    return lable;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)dataSource_boom
{
    if (!_dataSource_boom) {
        _dataSource_boom = [NSMutableArray array];
    }
    return _dataSource_boom;
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

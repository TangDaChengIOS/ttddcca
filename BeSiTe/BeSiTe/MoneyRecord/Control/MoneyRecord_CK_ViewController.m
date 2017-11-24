//
//  MoneyRecord_CK_ViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyRecord_CK_ViewController.h"
#import "MoneyRecordModel.h"

@interface MoneyRecord_CK_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RecordTableViewCell * headerView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation MoneyRecord_CK_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    kWeakSelf
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self requestDataForCunKuan];
    }];
    
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        weak_self.page += 1;
        [weak_self requestDataForCunKuan];
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


#pragma mark -- 请求存款数据
-(void)requestDataForCunKuan{
    [RequestManager getWithPath:@"getUserDepositInfos" params:[self para] success:^(id JSON) {
        [self.tableView.mj_header endRefreshing];

        self.dataSource = [MoneyRecordModel jsonToArray:JSON[@"data"]];
        [self.tableView reloadData];
        if ([JSON[@"hasNext"] integerValue] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        _page = [JSON[@"currentPage"] integerValue];
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCellReuseID forIndexPath:indexPath];
    [cell setCellWithModel:self.dataSource[indexPath.row] andCellType:RecordCellType_CunKuan];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



-(void)configSubViews{
    _headerView = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView.cellType = RecordCellType_CunKuan;
    [_headerView setTopCellWithVCType:RecordDetailControlType_CunKuan];
    [self.view addSubview:_headerView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 28, MAXWIDTH, MAXHEIGHT - 64 -28 - 50) style:UITableViewStylePlain];
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

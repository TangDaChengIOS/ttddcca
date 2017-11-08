//
//  PersonRecordSearchViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonRecordSearchViewController.h"
#import "RecordSelectToolView.h"
#import "RecordSearchTypeTableViewCell.h"
#import "DAYCalendarView.h"

@interface PersonRecordSearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel * totalMoneyLab;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSArray * dataSource;
@property (nonatomic,strong) RecordSelectToolView * recordTypeSelectView;
@property (nonatomic,strong) RecordSelectToolView * beginDateSelectView;
@property (nonatomic,strong) RecordSelectToolView * endDateSelectView;
@property (nonatomic,strong) UIButton * searchBtn;

@end

@implementation PersonRecordSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
//    DAYCalendarView * view = [[DAYCalendarView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, 300)];
//    [self.view addSubview:view];
    [self configSubViews];
}

-(void)configSubViews{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _totalMoneyLab.maxY, MAXWIDTH, MAXHEIGHT  - 64 - 66- 50)];
    _scrollView.backgroundColor = UIColorFromINTValue(230, 230, 230);
    [self.view addSubview:_scrollView];
    
    _totalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0, MAXWIDTH, 35)];
    _totalMoneyLab.backgroundColor = UIColorFromINTValue(245, 245, 245);
//    _totalMoneyLab.font = [UIFont boldSystemFontOfSize:13];
    _totalMoneyLab.text = @"05/06/2017";
    _totalMoneyLab.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_totalMoneyLab];
    

    
    _recordTypeSelectView = [[RecordSelectToolView alloc]init];
    _recordTypeSelectView.top = _totalMoneyLab.maxY;
    [_scrollView addSubview:_recordTypeSelectView];
    
    _beginDateSelectView = [[RecordSelectToolView alloc]init];
    [_scrollView addSubview:_beginDateSelectView];
    
    _endDateSelectView = [[RecordSelectToolView alloc]init];
    [_scrollView addSubview:_endDateSelectView];
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 12, MAXWIDTH - 24, 40)];
    _searchBtn.backgroundColor = UIColorFromINTValue(26, 174, 106);
    [_searchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_searchBtn setTitle:@"立即查询" forState:UIControlStateNormal];
    _searchBtn.layer.cornerRadius = 4.0f;
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_searchBtn];
    
    [self refreshSubViewTop];
}

-(void)searchBtnClick{
    DAYCalendarView * view = [[DAYCalendarView alloc]init];
    [self.view addSubview:view];
}


-(void)refreshSubViewTop{
    self.tableView.top = _recordTypeSelectView.maxY;
    _beginDateSelectView.top = _recordTypeSelectView.maxY + 210;
    _endDateSelectView.top = _beginDateSelectView.maxY + 5;
    _searchBtn.top = _endDateSelectView.maxY + 10;
    _scrollView.contentSize = CGSizeMake(MAXWIDTH, _searchBtn.maxY + 20);

}


#pragma mark -- tableView delegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordSearchTypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kRecordSearchTypeTableViewCellReuseID forIndexPath:indexPath];
    cell.isSingleLine = (indexPath.row + 1) % 2 ;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}



-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, 210) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[RecordSearchTypeTableViewCell class] forCellReuseIdentifier:kRecordSearchTypeTableViewCellReuseID];
        [_scrollView addSubview:_tableView];
    }
    return _tableView;
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

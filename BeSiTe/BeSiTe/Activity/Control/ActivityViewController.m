//
//  ActivityViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ActivityViewController.h"
#import "OnlyShowTimeTableViewCell.h"
#import "ActivityTableViewCell.h"
#import "ActivityModel.h"
#import "GamesMenuView.h"

@interface ActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) BSTNoDataView * noDataView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠活动";

    _selectedRow = -1;
    [self configSubViews];
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self requestData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weak_self.page += 1;
        [weak_self requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readUnReadMsgNums) name:kGetUnReadMsgNumsSuccessNotification object:nil];

}
-(void)readUnReadMsgNums
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([BSTSingle defaultSingle].user) {
            [(UIBarButtonItem_withBadge *)self.navigationItem.rightBarButtonItem setBadgeValue:[BSTSingle defaultSingle].totalNums];
        }
    });
}
#pragma mark -- viewAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readUnReadMsgNums];

}
-(void)requestData{
    
    NSDictionary * dict = @{@"pageNo":@(_page),
                            @"pageSize":@"10"};
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"favActivity" params:dict success:^(id JSON,BOOL isSuccess) {
        
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        
        NSDictionary * dict = JSON[@"page"];
        NSArray * data = dict[@"data"];
        if (weak_self.page == 1) {
            [weak_self.dataSource removeAllObjects];
        }
        [weak_self.dataSource addObjectsFromArray: [ActivityModel jsonToArray:data]];
        [weak_self.tableView reloadData];
        if ([dict[@"hasNext"] integerValue] == 0) {
            [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (weak_self.dataSource.count == 0) {
            [weak_self.tableView addSubview:weak_self.noDataView];
        }else{
            [weak_self.noDataView removeFromSuperview];
        }
        
        weak_self.page = [dict[@"currentPage"] integerValue];
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}



#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count * 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2  == 0) {
        OnlyShowTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOnlyShowTimeTableViewCellReuseID forIndexPath:indexPath];
        ActivityModel * model = self.dataSource[indexPath.row /2];
        [cell setTimeStr:model.createdTime];
        return cell;
    }
    else{
        ActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kActivityTableViewCellReuseID forIndexPath:indexPath];
        ActivityModel * model = self.dataSource[indexPath.row /2];
        BOOL open = (_selectedRow == indexPath.row ? YES : NO);
        [cell setCellWithModel:model isOpenState:open];
        if (model.type == 2) {
            cell.beginPlayGameBlock = ^(GamesModel * gameModel){
                [GamesMenuView showWithModel:gameModel];
            };
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2  == 0) {
    
    }else{
        ActivityModel * model = self.dataSource[indexPath.row /2];
        if (model.isRead == 0 && [BSTSingle defaultSingle].user) {
            [self readFavActiyityWithID:model.id];
            model.isRead = 1;
            [BSTSingle defaultSingle].activityUnreadNum -=1;
            [self.tabBarItem setBadgeValue:[ZZTextInput getBadgeValue:[BSTSingle defaultSingle].activityUnreadNum]];
        }
//        if (model.type == 2) {
//            if (model.game) {
//                [GamesMenuView showWithModel:model.game];
//            }
//            return;
//        }
        if (_selectedRow == indexPath.row) {
            _selectedRow =-1;
        }
        else{
            _selectedRow = indexPath.row;
        }
        [tableView reloadData];
    }
}

-(void)readFavActiyityWithID:(NSString *)activityID
{
    [RequestManager postManagerDataWithPath:@"favRead" params:@{@"actId":activityID} success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
    } failure:^(NSError *error) {
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2  == 0) {
        return 38;
    }
    else{
        if (_selectedRow == indexPath.row) {
            return 65 + 265;
        }
        else{
            return 65;
        }
    }
}



-(void)configSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT - 64 -49) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorFromINTValue(230, 230, 230);

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[OnlyShowTimeTableViewCell class] forCellReuseIdentifier:kOnlyShowTimeTableViewCellReuseID];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:nil] forCellReuseIdentifier:kActivityTableViewCellReuseID];
    [self.view addSubview:_tableView];

    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_left_img") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    if ([BSTSingle defaultSingle].user) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem_withBadge alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_right_mail_icon") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"common_navgation_right_img") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }
        
    __weak typeof(self)weakSelf = self;
    
    //侧滑菜单配置
    [self xw_registerToInteractiveTransitionWithDirection:XWInteractiveTransitionGestureDirectionRight transitonBlock:^(CGPoint startPoint){
        [weakSelf xw_transition];
    } edgeSpacing: 80];
    
}

-(void)leftBarButtonItemClick{
    [self xw_transition];
}

-(void)rightBarButtonItemClick
{
    if ([BSTSingle defaultSingle].user) {
        MessageViewController * msgVC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
        [self pushVC:msgVC];
    }else{
        [LoginViewController presentLoginViewController];
    }
}

-(BSTNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[BSTNoDataView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.isMsg = YES;
        _noDataView.tipsLab.text = @"暂无数据";
        _noDataView.backgroundColor = kWhiteColor;
    }
    return _noDataView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGetUnReadMsgNumsSuccessNotification object:nil];
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

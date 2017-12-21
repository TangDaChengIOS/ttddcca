//
//  MessageViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MessageViewController.h"
#import "UIButton_withBadge.h"
#import "MessageTableViewCell.h"
#import "SystemNoticesModel.h"
#import "UserMsgModel.h"
#import "ReplyMsgViewController.h"
#import "EmailTypeViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton_withBadge *systemMsgBtn;//系统消息按钮
@property (weak, nonatomic) IBOutlet UIButton_withBadge *personMsgBtn;//个人消息按钮
@property (weak, nonatomic) IBOutlet UILabel *topLable;//tips标签
@property (weak, nonatomic) IBOutlet UITableView *tableView;//列表

@property (nonatomic,assign) NSInteger selectIndex;//当前展开的列表——行
@property (nonatomic,assign) BOOL isSelectSystem;//yes系统消息，No个人消息

@property (nonatomic,strong) UIButton * titleViewBtn;//导航栏TitleView
@property (nonatomic,strong) UIView * sendNewMsgBackView;//发送新消息按钮父视图
@property (nonatomic,strong) UIButton * sendNewMsgBtn;//发送新消息按钮

@property (nonatomic,strong) NSMutableArray * dataSource;//系统消息数据源
@property (nonatomic,strong) NSMutableArray * personMsgDataSource;//个人消息数据源
@property (nonatomic,assign) NSInteger page;//系统消息页码
@property (nonatomic,assign) NSInteger person_page;//个人消息页码

@property (nonatomic,strong) BSTNoDataView * noDataView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readUnReadMsgNums) name:kGetUnReadMsgNumsSuccessNotification object:nil];
    
    [self configSubViews];
    
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weak_self.isSelectSystem) {
            weak_self.page = 1;
        }else{
            weak_self.person_page = 1;
        }
        [weak_self requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weak_self.isSelectSystem) {
            weak_self.page += 1;
        }else{
            weak_self.person_page += 1;
        }
        [weak_self requestData];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readUnReadMsgNums];
    [RequestCommonData getUnReadMsgNums];//先读取，后请求
    
    if ([BSTSingle defaultSingle].user) {
        [_titleViewBtn setImage:KIMAGE_Ori([[BSTSingle defaultSingle].user getVipImageStr]) forState:UIControlStateNormal];
        [_titleViewBtn setTitle:[BSTSingle defaultSingle].user.accountName forState:UIControlStateNormal];
    }else{
        [_titleViewBtn setImage:nil forState:UIControlStateNormal];
        [_titleViewBtn setTitle:@"未登录" forState:UIControlStateNormal];
    }
    [self.tableView.mj_header beginRefreshing];
}


-(void)requestData
{
    if (_isSelectSystem) {
        [self requestSystemNotices];
    }
    else{
        [self requestPersonMsg];
    }
}
#pragma mark -- 获取未读消息数量
-(void)readUnReadMsgNums
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.personMsgBtn setBadgeValue:[BSTSingle defaultSingle].msgNums];
        [self.systemMsgBtn setBadgeValue:[BSTSingle defaultSingle].noticeNums];
    });
}

-(void)requestSystemNotices
{
    NSDictionary * dict = @{@"pageNo":[NSString stringWithFormat:@"%ld",_page],
                            @"pageSize":@"20"};
    kWeakSelf
    [RequestManager getWithPath:@"querySystemNotices" params:dict success:^(id JSON ,BOOL isSuccess) {
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
        [weak_self.dataSource addObjectsFromArray: [SystemNoticesModel jsonToArray:JSON[@"data"]]];
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

-(void)requestPersonMsg
{
    NSDictionary * dict = @{@"pageNo":[NSString stringWithFormat:@"%ld",_person_page],
                            @"pageSize":@"20"};
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"user/msgs" params:dict success:^(id JSON ,BOOL isSuccess) {
        NSLog(@"%@",JSON);
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        NSDictionary * resultDict = JSON[@"page"];
        if (weak_self.person_page == 1) {
            [weak_self.personMsgDataSource removeAllObjects];
        }
        [weak_self.personMsgDataSource addObjectsFromArray: [UserMsgModel jsonToArray:resultDict[@"data"]]];
        [weak_self.tableView reloadData];
        if ([resultDict[@"hasNext"] integerValue] == 0) {
            [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
//        if (weak_self.personMsgDataSource.count == 0) {
//            [weak_self.tableView addSubview:weak_self.noDataView];
//        }else{
//            [weak_self.noDataView removeFromSuperview];
//        }
        _person_page = [resultDict[@"currentPage"] integerValue];
    } failure:^(NSError *error) {
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];

}



#pragma mark -- tableView delegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSelectSystem) {
        return self.dataSource.count;
    }
    else{
        return self.personMsgDataSource.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMessageTableViewCellReuseID forIndexPath:indexPath];

    BOOL isOpen = (_selectIndex == indexPath.row ? YES : NO);
    if (_isSelectSystem) {
        [cell setSystemCellWithModel:self.dataSource[indexPath.row] isOpenState:isOpen];
    }
    else{
        kWeakSelf
        [cell setUserMsgCellWithModel:self.personMsgDataSource[indexPath.row] isOpenState:isOpen];
        cell.replyBlock = ^(UserMsgModel * mdoel){
            ReplyMsgViewController * replyVC = [[ReplyMsgViewController alloc]initWithNibName:@"ReplyMsgViewController" bundle:nil];
            replyVC.model = mdoel;
            [weak_self pushVC:replyVC];
        };
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == indexPath.row) {
        _selectIndex = -1;
    }else{
        _selectIndex = indexPath.row;
    }
    if (_isSelectSystem) {
        SystemNoticesModel * model = self.dataSource[indexPath.row];
        if ([model.status isEqualToString:@"0"]) {
            [self readSystemMsgWithID:model.noticeId];
            model.status = @"1";
            [BSTSingle defaultSingle].noticeNums -= 1;
            [self.systemMsgBtn setBadgeValue:[BSTSingle defaultSingle].noticeNums];
        }
    }else{
        UserMsgModel * model = self.personMsgDataSource[indexPath.row];
        if ([model.status isEqualToString:@"0"]) {
            [self readUserMsgWithID:model.msgId];
            model.status = @"1";
            [BSTSingle defaultSingle].msgNums -= 1;
            [self.personMsgBtn setBadgeValue:[BSTSingle defaultSingle].msgNums];
        }
    }
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == indexPath.row) {
        return _isSelectSystem ? 199 : 244;
    }
    return 54;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isSelectSystem) {
        return 0.01;
    }else{
        return 100;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_isSelectSystem) {
        return nil;
    }else{
        return self.sendNewMsgBackView;
    }
}

#pragma mark -- 阅读系统公告接口
-(void)readSystemMsgWithID:(NSString *)msgID{
    [RequestManager postWithPath:@"readSystemNotice" params:@{@"noticeId":msgID} success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 阅读个人信息接口
-(void)readUserMsgWithID:(NSString *)msgID{
    [RequestManager postManagerDataWithPath:@"user/msgRead" params:@{@"msgId":msgID} success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark -- 切换 系统公告、个人信息
- (IBAction)systemMsgBtnClick:(id)sender {
    _isSelectSystem = YES;
    _selectIndex = -1;
    [self refreshUI:YES];

    if (self.dataSource.count) {
        [self.tableView reloadData];
        [self.noDataView removeFromSuperview];
        
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
}
- (IBAction)personMsgBtn:(id)sender {
    _isSelectSystem = NO;
    _selectIndex = -1;
    [self refreshUI:NO];
    if (self.personMsgDataSource.count) {
        [self.tableView reloadData];
        [self.noDataView removeFromSuperview];
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)refreshUI:(BOOL)isLeft
{
    self.personMsgBtn.backgroundColor = isLeft ?  UIColorFromINTValue(72, 190, 204) : kWhiteColor;
    [self.personMsgBtn setTitleColor:( isLeft ? kWhiteColor : UIColorFromINTValue(33, 149, 167) ) forState:UIControlStateNormal];
    
    self.systemMsgBtn.backgroundColor = isLeft ? kWhiteColor : UIColorFromINTValue(72, 190, 204)  ;
    [self.systemMsgBtn setTitleColor:( isLeft ?  UIColorFromINTValue(33, 149, 167) :kWhiteColor ) forState:UIControlStateNormal];
    if (isLeft) {
        [self.systemMsgBtn setImage:[KIMAGE(@"common_tab_select_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.systemMsgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self.personMsgBtn setImage:nil forState:UIControlStateNormal];
        
    }else{
        [self.personMsgBtn setImage:[KIMAGE(@"common_tab_select_icon")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.personMsgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self.systemMsgBtn setImage:nil forState:UIControlStateNormal];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.personMsgBtn setBadgeValue:[BSTSingle defaultSingle].msgNums];
        [self.systemMsgBtn setBadgeValue:[BSTSingle defaultSingle].noticeNums];
    });

}

#pragma mark -- 初始化操作
-(void)configSubViews
{
    _selectIndex = -1;
    _isSelectSystem = YES;
    self.navigationItem.titleView = self.titleViewBtn;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:kMessageTableViewCellReuseID];
    [self refreshUI:YES];
}
#pragma mark -- lazy
-(UIButton *)titleViewBtn
{
    if (!_titleViewBtn) {
        _titleViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [_titleViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    }
    return _titleViewBtn;
}

-(UIView *)sendNewMsgBackView
{
    if (!_sendNewMsgBackView) {
        _sendNewMsgBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, 100)];
        _sendNewMsgBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, MAXWIDTH - 30, 40)];
        _sendNewMsgBtn.backgroundColor = UIColorFromINTValue(30, 180, 222);
        [_sendNewMsgBtn setTitle:@"发送新消息" forState:UIControlStateNormal];
        [_sendNewMsgBtn addTarget:self action:@selector(sendNewMsgClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendNewMsgBackView addSubview:_sendNewMsgBtn];
    }
    return _sendNewMsgBackView;
}


-(void)sendNewMsgClick
{
    EmailTypeViewController * typeVC = [[EmailTypeViewController alloc]init];
    typeVC.isClickItemGotoNextPage = YES;
    [self pushVC:typeVC];
}

-(BSTNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[BSTNoDataView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.isMsg = YES;
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
-(NSMutableArray *)personMsgDataSource
{
    if (!_personMsgDataSource) {
        _personMsgDataSource = [NSMutableArray array];
    }
    return _personMsgDataSource;
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

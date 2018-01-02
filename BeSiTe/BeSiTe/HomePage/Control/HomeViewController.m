//
//  HomeViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderView.h"
#import "HomeItemCollectionViewCell.h"
#import "GameListPageViewController.h"
#import "RegisterPageOneViewController.h"
#import "EditPhoneNumberView.h"
#import "YQCollectionViewFlowLayout.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    CGFloat _margin;
    CGFloat _itemWidth;
}

@property (nonatomic,strong) UIImageView * navRightCornImg;//导航栏右下角的彩色标记
@property (nonatomic,strong) HomeHeaderView * headerView;//轮播图、最近游戏、跑马灯
@property (nonatomic,strong) UICollectionView * collectionView;//平台列表
@property (nonatomic,strong) NSMutableArray * dataSource;//数据源
@property (nonatomic,strong) NSTimer * timer;//定时器，循环请求滚屏公告数据
@property (nonatomic,assign) BOOL isRequestData;//是否正在请求数据

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _margin = 9;
    _itemWidth = (MAXWIDTH - _margin * 5)/ 4;
    [self configSubViews];

    kWeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self requestData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeADSRefreshTime) name:@"ADSRollTimeChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readUnReadMsgNums) name:kGetUnReadMsgNumsSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readNoticesData) name:kGetNoticesDataSuccessNotification object:nil];


    [self.collectionView.mj_header beginRefreshing];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)requestData
{
    if (self.isRequestData || self.headerView.isRequestData) {
        return;
    }
    [self.headerView refreshData];
    self.isRequestData = YES;

    kWeakSelf
    [RequestManager getManagerDataWithPath:@"gameCompanys" params:nil success:^(id JSON ,BOOL isSuccess) {
        weak_self.isRequestData = NO;
        [weak_self endRefreshState];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        //GamesCompanyModel jsonToArray 有重写父类方法，保存数据到单例
        weak_self.dataSource = [GamesCompanyModel jsonToArray:JSON];
        [weak_self.collectionView reloadData];
    } failure:^(NSError *error) {
        weak_self.isRequestData = NO;
        [weak_self endRefreshState];
    }];
    
    [RequestCommonData getNoticesData];
}


-(void)endRefreshState{
    if (!self.isRequestData && !self.headerView.isRequestData) {
        [self.collectionView.mj_header endRefreshing];
    }
}


#pragma mark -- collectionView delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count + 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeItemCollectionViewCellReuseID forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.itemType = HomeItemTypeDefault;
        [cell setCellWithModel:self.dataSource[indexPath.row]];
    }else{
        cell.itemType = HomeItemTypeNodata;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.dataSource.count) return;
    
    GameListPageViewController * menuVC = [[GameListPageViewController alloc]init];
    menuVC.selectIndex = indexPath.item;
    GamesCompanyModel * model = self.dataSource[indexPath.row];
    menuVC.selectCompanyCode = model.companyCode;
    [self pushVC:menuVC];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader ) {
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewkey" forIndexPath:indexPath];
        if (view.subviews.count ==0) {
            [view addSubview:self.headerView];
        }
        return view;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_itemWidth, 100 * kPROPORTION);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(MAXWIDTH, 167 * kPROPORTION + 77 + 9);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return _margin;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return _margin;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, _margin, 0, _margin);
}


#pragma mark -- subViews
-(void)configSubViews
{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_left_img") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    if ([BSTSingle defaultSingle].user) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem_withBadge alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_right_mail_icon") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"common_navgation_right_img") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }
    
    [self.view addSubview:self.collectionView];
    
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

#pragma mark -- Lazy
-(UIImageView *)navRightCornImg
{
    if (!_navRightCornImg) {
        _navRightCornImg = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_tag_img")];
        _navRightCornImg.frame = CGRectMake(MAXWIDTH - 11.5, 44 - 17.5, 11.5, 17.5);
    }
    return _navRightCornImg;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        YQCollectionViewFlowLayout * lay = [[YQCollectionViewFlowLayout alloc]init];
        lay.navHeight = 0;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, MAXWIDTH , MAXHEIGHT - 49 - 64  ) collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromINTValue(231, 231, 231);
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewkey"];
        [_collectionView registerClass:[HomeItemCollectionViewCell class] forCellWithReuseIdentifier:kHomeItemCollectionViewCellReuseID];
    }
    return _collectionView;
}

-(HomeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[HomeHeaderView alloc]init];
        kWeakSelf
        _headerView.finishRequestBlock = ^(){
            [weak_self endRefreshState];
        };
    }
    return _headerView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark -- 读取未读消息数
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

    [self.navigationController.navigationBar addSubview:self.navRightCornImg];
    [self readUnReadMsgNums];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navRightCornImg removeFromSuperview];
}

#pragma mark -- 更新轮播图的翻页时间间隔
-(void)changeADSRefreshTime{
    self.headerView.bannerView.autoScrollTimeInterval = [BSTSingle defaultSingle].adsRollTime ;
}

#pragma mark -- 滚屏公告相关
-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(timerRunning) userInfo:nil repeats:YES];
    }
    return _timer;
}
//间隔请求数据
-(void)timerRunning{
    [RequestCommonData getNoticesData];
}
//接到通知，展示数据
-(void)readNoticesData{
    [self.headerView handleNotices];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ADSRollTimeChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGetNoticesDataSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGetUnReadMsgNumsSuccessNotification object:nil];
}
@end

//
//  GameListPageViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameListPageViewController.h"
#import "GameListPageHeaderView.h"
#import "GameItemCollectionViewCell.h"
#import "GamesMenuView.h"
#import "GameSearchViewController.h"
#include "GamesCanScrollTipsView.h"
#import "GameListPageCollectionReusableView.h"
#import <AFNetworking/AFNetworking.h>


@interface GameListPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}

@property (nonatomic,strong) GameListPageHeaderView * headerView;//顶部菜单及滚屏通告
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UILabel * collectionHeaderView;//展示搜索结果时显示
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSMutableArray * titleDataSource;

@property (nonatomic,assign) BOOL isShowSearchResult;//当前是展示搜索结果

@property (nonatomic,assign) BOOL isHaveShowTips;//显示可滑动提示

@property (nonatomic,copy) NSString * searchKey;


@end

@implementation GameListPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemWidth = (MAXWIDTH - 60)/3;
    _itemHeight = _itemWidth * 78 / 104 + 20;
    
    [self configSubViews];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    self.isHaveShowTips = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstEnterGameListPage];
    
    [self.headerView setSelectedItem:self.selectIndex];
    self.isShowSearchResult = NO;
    [self readNoticesData];
    kWeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self requestData];
    }];
    [self dealData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readNoticesData) name:kGetNoticesDataSuccessNotification object:nil];

}

#pragma mark -- 读取通知，滚屏公告
-(void)readNoticesData{
    [self.headerView.scrollTextView  startScrollWithAttributedString:[BSTSingle defaultSingle].notices];
}

#pragma mark -- 判断是否有缓存数据
-(void)dealData
{
    [self.titleDataSource removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.collectionView reloadData];
    
    id objec = [[NSUserDefaults standardUserDefaults]objectForKey:self.selectCompanyCode];
    if (objec) {
        for (NSDictionary * dict in objec) {
            NSString * key = dict[@"plateform"];
            [self.titleDataSource addObject:key];
            NSMutableArray * array = [GamesModel jsonToArray:dict[@"list"]];
            [self.dataSource addObject:array];
        }
        [self.collectionView reloadData];
        [self.collectionView scrollToTop];
        if ([self.collectionView.mj_header isRefreshing] ) {
            [self.collectionView.mj_header endRefreshing];
        }
    }else{
        if ([self.collectionView.mj_header isRefreshing] ) {
            [self requestData];
        }else{
            [self.collectionView.mj_header beginRefreshing];
        }
    }
}
#pragma mark -- 从网络加载数据
-(void)requestData
{
    [self.titleDataSource removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.collectionView reloadData];
    
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setValue:@"IOS" forKey:@"appOs"];
    if (self.searchKey) {
        [mDict setValue:self.searchKey forKey:@"key"];
    }
    else{
        [mDict setValue:_selectCompanyCode forKey:@"companyCode"];
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",ManagerBaseURL,@"games"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSSet *set = [[NSSet alloc] initWithObjects:@"text/plain",@"text/html", @"application/json", nil];
    manager.responseSerializer.acceptableContentTypes = set;
    manager.requestSerializer.timeoutInterval = 10;
    if ([BSTSingle defaultSingle].user) {
        [manager.requestSerializer setValue:[BSTSingle defaultSingle].user.token forHTTPHeaderField:@"ACCESS_TOKEN"];
    }
    
    kWeakSelf
    [manager GET:url parameters:mDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSInteger retCode = [responseObject[@"retCode"] integerValue];
            if (retCode == 0)
            {
                NSArray * JSON = [responseObject objectForKey:@"data"];
                
                NSString * fullUrl = task.originalRequest.URL.absoluteString;
                BOOL isSearchResult = YES;
                if ([fullUrl componentsSeparatedByString:@"companyCode"].count > 1) {
                    isSearchResult = NO;
                }
                
                if (weak_self.searchKey)
                {
                    if (!isSearchResult) {
                        return ;//在需要显示搜索结果的情况下，当前获取的是单个平台的游戏
                    }
//                    NSArray * arr = [fullUrl componentsSeparatedByString:@"key="];
//                    //防止弱网情况下，频繁切换搜索，导致显示的结果不正确
//                    if (arr.count <= 1 || ![[arr lastObject]isEqualToString:weak_self.searchKey] )
//                    {
//                        return;
//                    }
                }else
                {
                    if (isSearchResult) {
                        return;//在需要显示单个平台的游戏的情况下，当前获取的是搜索结果
                    }
                    
                    if (JSON.count > 0) {
                        NSDictionary * dict_f = JSON[0];
                        NSString * key_f = dict_f[@"plateform"];
                        
                        [[NSUserDefaults standardUserDefaults]setValue:JSON forKey:key_f];//缓存单个平台的游戏数据
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        if (![key_f isEqualToString:weak_self.selectCompanyCode]) {
                            return;//防止获取平台结果时，已经切换其他平台
                        }
                    }
                }
                
                NSInteger totalNum = 0;
                for (NSDictionary * dict in JSON) {
                    NSString * key = dict[@"plateform"];
                    [weak_self.titleDataSource addObject:key];
                    NSMutableArray * array = [GamesModel jsonToArray:dict[@"list"]];
                    totalNum += array.count;
                    [weak_self.dataSource addObject:array];
                }
                
                [weak_self.collectionView reloadData];
                [weak_self.collectionView scrollToTop];
                [weak_self setSearchResultTitle:totalNum];
                [weak_self ensureCanScroll];
                [weak_self.collectionView.mj_header endRefreshing];
            }
            else{
                [weak_self.collectionView.mj_header endRefreshing];
                if ([RequestManager isNeedPresentLoginPageForReturnCode:retCode]){
                    return;
                }
                TTAlert(responseObject[@"retMsg"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weak_self.collectionView.mj_header endRefreshing];
            if (error.code == -1001) {
                TTAlert(kOutTimeError);
            }else{
                TTAlert(kNetError);
            }
        }];
}

//显示可以滚动的tips
-(void)ensureCanScroll
{
    if (self.isHaveShowTips || self.dataSource.count == 0) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        kWeakSelf
        [GamesCanScrollTipsView showOnView:self.view withFinshBlock:^{
            [UIView animateWithDuration:1 animations:^{
                [weak_self.collectionView setContentOffset:CGPointMake(0, 200) animated:YES];
            }];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstEnterGameListPage];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.isHaveShowTips = YES;
    });
}


#pragma mark -- collectionView delegates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [(NSArray *)self.dataSource[section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameItemCollectionViewCellReuseID forIndexPath:indexPath];
    
    [cell setCellWithModel:self.dataSource[indexPath.section][indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [GamesMenuView showWithModel:self.dataSource[indexPath.section][indexPath.item]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader )
    {
        GameListPageCollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGameListPageCollectionReusableViewReuseID forIndexPath:indexPath];
        [view setIsShowResult:self.isShowSearchResult];
        [view setCellWithCompanyName:self.titleDataSource[indexPath.section] andNums:[self.dataSource[indexPath.section] count]];

        return view;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_itemWidth,_itemHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(MAXWIDTH, 25);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

#pragma mark -- Lazy
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * lay = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,75 *kPROPORTION + 30, MAXWIDTH , MAXHEIGHT - 64 -(75 *kPROPORTION + 30)) collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kWhiteColor;// UIColorFromINTValue(231, 231, 231);
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[GameListPageCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGameListPageCollectionReusableViewReuseID];
        [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:kGameItemCollectionViewCellReuseID];
    }
    return _collectionView;
}
#pragma mark -- 页面顶部菜单
-(GameListPageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[GameListPageHeaderView alloc]init];
        kWeakSelf
        _headerView.selectGameCompanyBlock = ^(NSString * companyCode){
            weak_self.selectCompanyCode = companyCode;
            weak_self.isShowSearchResult = NO;
            weak_self.searchKey = nil;
            [weak_self refreshUI];
            [weak_self dealData];
        };
        _headerView.gotoSearchBlock = ^(){
            GameSearchViewController * contro = [[GameSearchViewController alloc]init];
            contro.searchBlock = ^(NSString * searchKey){
                weak_self.isShowSearchResult = YES;
                weak_self.searchKey = searchKey;
                [weak_self refreshUI];

                if ([weak_self.collectionView.mj_header isRefreshing] ) {
                    [weak_self requestData];
                }else{
                    [weak_self.collectionView.mj_header beginRefreshing];
                }
            };
            [weak_self pushVC:contro];
        };
    }
    return _headerView;
}


-(void)refreshUI{
    if (self.isShowSearchResult) {
        if (!_collectionHeaderView){
            [self.collectionView setY_offset:20];
            [self.view addSubview:self.collectionHeaderView];
        }
//        NSMutableAttributedString * mAStr = [[NSMutableAttributedString alloc]initWithString:@"搜索中...." attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(4, 159, 189),NSFontAttributeName:kFont(12)}];
        _collectionHeaderView.attributedText = nil;
    }else{
        if (_collectionHeaderView){
            [_collectionHeaderView removeFromSuperview];
            _collectionHeaderView = nil;
            [self.collectionView setY_offset:-20];
        }
    }
}

-(void)setSearchResultTitle:(NSInteger)totalNums
{
    if (!self.isShowSearchResult) {
        return;
    }
    NSMutableAttributedString * mAStr = [[NSMutableAttributedString alloc]initWithString:@"贝斯特为你找到相关结果个" attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(4, 159, 189),NSFontAttributeName:kFont(12)}];
    NSAttributedString * mAStr_num = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",totalNums] attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(255, 0, 0),NSFontAttributeName:kFont(12)}];
    [mAStr insertAttributedString:mAStr_num atIndex:mAStr.length-1];
    _collectionHeaderView.attributedText = mAStr;
}

#pragma mark -- 显示搜索结果时，collectionview顶上的label
-(UILabel *)collectionHeaderView
{
    if (!_collectionHeaderView) {
        _collectionHeaderView = [[UILabel alloc]initWithFrame:CGRectMake(0, self.collectionView.top - 20, MAXWIDTH, 20)];
        _collectionHeaderView.backgroundColor = kWhiteColor;
        _collectionHeaderView.textColor = kBlackColor;
        _collectionHeaderView.textAlignment = NSTextAlignmentCenter;
        _collectionHeaderView.font = kFont(12);
    }
    return _collectionHeaderView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)titleDataSource
{
    if (!_titleDataSource) {
        _titleDataSource = [NSMutableArray array];
    }
    return _titleDataSource;
}


#pragma mark -- subViews
-(void)configSubViews
{
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGetNoticesDataSuccessNotification object:nil];
}


@end

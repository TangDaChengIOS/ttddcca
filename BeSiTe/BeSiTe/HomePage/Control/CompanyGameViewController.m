//
//  CompanyGameViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 18/1/4.
//  Copyright © 2018年 Tang. All rights reserved.
//

#import "CompanyGameViewController.h"

#import "GameItemCollectionViewCell.h"
#import "GamesMenuView.h"
#include "GamesCanScrollTipsView.h"
#import "GameListPageCollectionReusableView.h"
#import <AFNetworking/AFNetworking.h>

@interface CompanyGameViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}

@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UILabel * collectionHeaderView;//展示搜索结果时显示
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSMutableArray * titleDataSource;

@end

@implementation CompanyGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemWidth = (MAXWIDTH - 60)/3;
    _itemHeight = _itemWidth * 78 / 104 + 20;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];

    kWeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self requestData];
    }];
    
    [self refreshUI];
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

    }else{
        [self.collectionView.mj_header beginRefreshing];
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
    manager.requestSerializer.timeoutInterval = 20;
    if ([BSTSingle defaultSingle].user) {
        [manager.requestSerializer setValue:[BSTSingle defaultSingle].user.token forHTTPHeaderField:@"ACCESS_TOKEN"];
    }
    
    kWeakSelf
    [manager GET:url parameters:mDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weak_self.collectionView.mj_header endRefreshing];
        NSInteger retCode = [responseObject[@"retCode"] integerValue];
        if (retCode == 0)
        {
            NSArray * JSON = [responseObject objectForKey:@"data"];
            
            if (!weak_self.searchKey)
            {
                if (JSON.count > 0) {
                    NSDictionary * dict_f = JSON[0];
                    NSString * key_f = dict_f[@"plateform"];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:JSON forKey:key_f];//缓存单个平台的游戏数据
                    [[NSUserDefaults standardUserDefaults]synchronize];
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
        }
        else if (error.code == -1011){
            TTAlert(kDataError);
        }
        else{
            TTAlert(kNetError);
        }
    }];
}

//显示可以滚动的tips
-(void)ensureCanScroll
{
    self.isHaveShowTips = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstEnterGameListPage];

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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT - 75 * kPROPORTION - 94) collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kWhiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[GameListPageCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGameListPageCollectionReusableViewReuseID];
        [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:kGameItemCollectionViewCellReuseID];
    }
    return _collectionView;
}

-(void)refreshUI{
    if (self.isShowSearchResult) {
        if (!_collectionHeaderView){
            [self.collectionView setY_offset:20];
            [self.view addSubview:self.collectionHeaderView];
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end

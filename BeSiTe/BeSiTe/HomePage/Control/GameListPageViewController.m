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
    [self.headerView.scrollTextView  startScrollWithAttributedString:[BSTSingle defaultSingle].notices];
    self.isShowSearchResult = NO;
    
    kWeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self requestData];
    }];
    [self dealData];
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
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setValue:@"IOS" forKey:@"appOs"];
    if (self.searchKey) {
        [mDict setValue:self.searchKey forKey:@"key"];
    }
    else{
        [mDict setValue:_selectCompanyCode forKey:@"companyCode"];
    }
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"games" params:mDict success:^(id JSON ,BOOL isSuccess) {
        [weak_self.collectionView.mj_header endRefreshing];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        //存储数据到本地
        if (!weak_self.searchKey) {
            [[NSUserDefaults standardUserDefaults]setValue:JSON forKey:weak_self.selectCompanyCode];
            [[NSUserDefaults standardUserDefaults]synchronize];
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
    } failure:^(NSError *error) {
        [weak_self.collectionView.mj_header endRefreshing];
        if (error) {
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            kWeakSelf
            [GamesCanScrollTipsView showWithFinshBlock:^{
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
                [weak_self.collectionView.mj_header beginRefreshing];
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
        _collectionHeaderView.text = @"贝斯特为您找到相关结果4个";
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



@end

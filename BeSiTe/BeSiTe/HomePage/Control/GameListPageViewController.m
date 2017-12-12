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

@interface GameListPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}

@property (nonatomic,strong) GameListPageHeaderView * headerView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UILabel * sectionHeadLab;
//@property (nonatomic,strong) UILabel * collectionHeaderView;//展示搜索结果时显示
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,assign) BOOL isShowSearchResult;//当前是展示搜索结果

@property (nonatomic,assign) BOOL isHaveShowTips;//显示可滑动提示

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
    [self requestDataWithKey:nil];
}

-(void)requestDataWithKey:(NSString *)key
{
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    if (key) {
        [mDict setValue:key forKey:@"key"];
    }
    else{
        [mDict setValue:_selectCompanyCode forKey:@"companyCode"];
    }
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"games" params:mDict success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        NSLog(@"%@",JSON);
        weak_self.dataSource = [GamesModel jsonToArray:JSON];
        [weak_self.collectionView reloadData];
        [weak_self ensureCanScroll];
    } failure:^(NSError *error) {
        
    }];
}


-(void)ensureCanScroll
{
    if (self.isHaveShowTips || self.dataSource.count == 0) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            kWeakSelf
            [GamesCanScrollTipsView showWithFinshBlock:^{
                [weak_self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weak_self.dataSource.count -1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstEnterGameListPage];
            [[NSUserDefaults standardUserDefaults]synchronize];
            self.isHaveShowTips = YES;
    });

}


#pragma mark -- collectionView delegates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameItemCollectionViewCellReuseID forIndexPath:indexPath];
    
    [cell setCellWithModel:self.dataSource[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [GamesMenuView showWithModel:self.dataSource[indexPath.item]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader ) {
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewkey2" forIndexPath:indexPath];
        [view removeAllSubviews];

       view.backgroundColor = kWhiteColor;
       UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 15)];
       imageView.image = KIMAGE(@"home_gameTypeName_icon");
       [view addSubview:imageView];
       [view addSubview:self.sectionHeadLab];
       
       if (self.isShowSearchResult)
       {
           _sectionHeadLab.text = [NSString stringWithFormat:@"贝斯特为您找到相关结果%ld个",self.dataSource.count];

       }else{
           _sectionHeadLab.text = [NSString stringWithFormat:@"%@游戏%ld款",self.selectCompanyCode,self.dataSource.count];
       }
       _sectionHeadLab.left = imageView.maxX + 3;


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
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewkey2"];
        [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:kGameItemCollectionViewCellReuseID];
    }
    return _collectionView;
}

-(GameListPageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[GameListPageHeaderView alloc]init];
        kWeakSelf
        _headerView.selectGameCompanyBlock = ^(NSString * companyCode){
            weak_self.selectCompanyCode = companyCode;
            weak_self.isShowSearchResult = NO;
            [weak_self requestDataWithKey:nil];
        };
        _headerView.gotoSearchBlock = ^(){
            GameSearchViewController * contro = [[GameSearchViewController alloc]init];
            contro.searchBlock = ^(NSString * searchKey){
                weak_self.isShowSearchResult = YES;
                [weak_self requestDataWithKey:searchKey];
            };
            [weak_self pushVC:contro];
        };
    }
    return _headerView;
}
-(UILabel *)sectionHeadLab
{
    if (!_sectionHeadLab) {
        _sectionHeadLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 200, 15)];
        _sectionHeadLab.text = @"PNG游戏28款";
        _sectionHeadLab.textColor = kBlackColor;// UIColorFromINTValue(142, 146, 149);
        _sectionHeadLab.font = kFont(12);
    }
    return _sectionHeadLab;
}
//-(UILabel *)collectionHeaderView
//{
//    if (!_collectionHeaderView) {
//        _collectionHeaderView = [[UILabel alloc]initWithFrame:CGRectMake(0, self.collectionView.top - 20, MAXWIDTH, 20)];
//        _collectionHeaderView.backgroundColor = kWhiteColor;
//        _collectionHeaderView.text = @"贝斯特为您找到相关结果4个";
//        _collectionHeaderView.textColor = kBlackColor;
//        _collectionHeaderView.font = kFont(12);
//    }
//    return _collectionHeaderView;
//}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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

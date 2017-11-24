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

@interface GameListPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) GameListPageHeaderView * headerView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UILabel * sectionHeadLab;
@property (nonatomic,strong) UILabel * collectionHeaderView;//展示搜索结果时显示
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,assign) BOOL isShowSearchResult;//当前是展示搜索结果
@end

@implementation GameListPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    if (self.isShowSearchResult) {
        [self.collectionView setY_offset:20];
        [self.view addSubview:self.collectionHeaderView];
    }

    
    [self.headerView setSelectedItem:self.selectIndex];
    [self.headerView.scrollTextView  startScrollWithAttributedString:[BSTSingle defaultSingle].notices];

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
//    [mDict setValue:@"AG" forKey:@"userId"];

    [RequestManager getManagerDataWithPath:@"games" params:mDict success:^(id JSON) {
        NSLog(@"%@",JSON);
        self.dataSource = [GamesModel jsonToArray:JSON];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
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
        switch (indexPath.section) {
            case 0:
            {
                view.backgroundColor = kWhiteColor;
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 15)];
                imageView.image = KIMAGE(@"home_gameTypeName_icon");
                [view addSubview:imageView];
                [view addSubview:self.sectionHeadLab];
                _sectionHeadLab.text = [NSString stringWithFormat:@"%@游戏%ld款",self.selectCompanyCode,self.dataSource.count];
                _sectionHeadLab.left = imageView.maxX + 3;
            }
                break;
            case 1:
            {
                view.backgroundColor = UIColorFromINTValue(231, 231, 231);
                UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 15)];
                lab.text = @"PNG游戏28款";
                lab.textColor = kBlackColor;// UIColorFromINTValue(142, 146, 149);
                lab.font = kFont(12);
                [view addSubview:lab];
            }
                break;
            case 2:
            {
                view.backgroundColor = UIColorFromINTValue(231, 231, 231);
                UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 15)];
                lab.text = @"PNG游戏28款";
                lab.textColor = kBlackColor;// UIColorFromINTValue(142, 146, 149);
                lab.font = kFont(12);
                [view addSubview:lab];
            }
                break;
            default:
                break;
        }

        return view;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (MAXWIDTH - 60)/3;
    return CGSizeMake(w, w + 20);

//    return CGSizeMake(105* kPROPORTION, 80 * kPROPORTION + 20);
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
            [weak_self requestDataWithKey:nil];
        };
        _headerView.gotoSearchBlock = ^(){
            GameSearchViewController * contro = [[GameSearchViewController alloc]init];
            contro.searchBlock = ^(NSString * searchKey){
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
        _sectionHeadLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 15)];
        _sectionHeadLab.text = @"PNG游戏28款";
        _sectionHeadLab.textColor = kBlackColor;// UIColorFromINTValue(142, 146, 149);
        _sectionHeadLab.font = kFont(12);
//        _sectionHeadLab.textAlignment = NSTextAlignmentCenter;
//        _sectionHeadLab.backgroundColor = UIColorFromINTValue(60, 90, 95);
    }
    return _sectionHeadLab;
}
-(UILabel *)collectionHeaderView
{
    if (!_collectionHeaderView) {
        _collectionHeaderView = [[UILabel alloc]initWithFrame:CGRectMake(0, self.collectionView.top - 20, MAXWIDTH, 20)];
        _collectionHeaderView.backgroundColor = kWhiteColor;
        _collectionHeaderView.text = @"贝斯特为您找到相关结果4个";
        _collectionHeaderView.textColor = kBlackColor;// UIColorFromINTValue(142, 146, 149);
        _collectionHeaderView.font = kFont(12);
        //        _sectionHeadLab.textAlignment = NSTextAlignmentCenter;
        //        _sectionHeadLab.backgroundColor = UIColorFromINTValue(60, 90, 95);
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
#pragma mark -- subViews
-(void)configSubViews
{
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"common_navgation_right_img") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)rightBarButtonItemClick{
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

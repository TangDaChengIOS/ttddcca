//
//  HomeViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuViewController.h"
#import "XWDrawerAnimator.h"
#import "HomeHeaderView.h"
#import "HomeItemCollectionViewCell.h"
#import "GameListPageViewController.h"
#import "LoginViewController.h"
#import "RegisterPageOneViewController.h"
#import "EditPhoneNumberView.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIImageView * navRightCornImg;
@property (nonatomic,strong) HomeHeaderView * headerView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    __weak typeof(self)weakSelf = self;
   
    //侧滑菜单配置
    [self xw_registerToInteractiveTransitionWithDirection:XWInteractiveTransitionGestureDirectionRight transitonBlock:^(CGPoint startPoint){
        [weakSelf xw_transition];
    } edgeSpacing: 80];
    kWeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self requestData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationNeedVerifyPhoneNum) name:@"ApplicationNeedVerifyPhoneNum" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeADSRefreshTime) name:@"ADSRollTimeChangedNotification" object:nil];
    
    [self.collectionView.mj_header beginRefreshing];

}

-(void)requestData
{
    [self.headerView refreshData];

    kWeakSelf
    [RequestManager getManagerDataWithPath:@"gameCompanys" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        //GamesCompanyModel jsonToArray 有重写父类方法，保存数据到单例
        weak_self.dataSource = [GamesCompanyModel jsonToArray:JSON];
        [weak_self.collectionView reloadData];
        [weak_self.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        
    }];
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
    return CGSizeMake(81* kPROPORTION, 97 * kPROPORTION);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(MAXWIDTH, 167 * kPROPORTION + 77);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 6;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 6;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(9, 9, 0, 9);
}


#pragma mark -- subViews
-(void)configSubViews
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_left_img") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"common_navgation_right_img") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    [self.view addSubview:self.collectionView];

}

-(void)leftBarButtonItemClick{
    [self xw_transition];
}

-(void)rightBarButtonItemClick
{
    if ([BSTSingle defaultSingle].user) {
        [self.tabBarController setSelectedIndex:2];
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
        UICollectionViewFlowLayout * lay = [[UICollectionViewFlowLayout alloc]init];
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
    }
    return _headerView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark -- 侧滑
- (void)xw_transition{
    XWDrawerAnimatorDirection direction =  XWDrawerAnimatorDirectionLeft;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:LeftMenuWidth];
    animator.toDuration = 0.5;
    animator.backDuration = 0.5;
    animator.parallaxEnable = YES;
    
    MenuViewController * menuVC = [[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    [self xw_presentViewController:menuVC withAnimator:animator];
    __weak typeof(self)weakSelf = self;
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf _xw_back];
    }];
}

- (void)_xw_back{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- viewAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar addSubview:self.navRightCornImg];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navRightCornImg removeFromSuperview];
}

#pragma mark -- applicationNeedVerifyPhoneNum
-(void)applicationNeedVerifyPhoneNum{
    self.tabBarController.selectedIndex = 2;
    [EditPhoneNumberView showWithEditPhoneType:EditPhoneNumberViewTypeVerify];
}


-(void)changeADSRefreshTime{
    self.headerView.bannerView.autoScrollTimeInterval = [BSTSingle defaultSingle].adsRollTime ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ApplicationNeedVerifyPhoneNum" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ADSRollTimeChangedNotification" object:nil];
}
@end

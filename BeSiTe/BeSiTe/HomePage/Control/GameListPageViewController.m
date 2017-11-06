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

@interface GameListPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) GameListPageHeaderView * headerView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UILabel * sectionHeadLab;
@end

@implementation GameListPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

-(void)requestData{
//    [RequestManager postWithPath:@"/sendSmsCode" params:@{@"mobile":@"18026767853",@"type":@"1"} method:@"post" success:^(id JSON) {
//        MyLog(@"%@", JSON);
//    } failure:^(NSError *error) {
//        MyLog(@"%@", error.description);
//    }];
}

#pragma mark -- collectionView delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 28;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameItemCollectionViewCellReuseID forIndexPath:indexPath];
    [cell setCell];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [GamesMenuView show];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader ) {
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewkey2" forIndexPath:indexPath];
        if (view.subviews.count ==0) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 15)];
            imageView.image = KIMAGE(@"home_gameTypeName_icon");
            [view addSubview:imageView];
            [view addSubview:self.sectionHeadLab];
            _sectionHeadLab.left = imageView.maxX + 3;
            //[view addSubview:self.headerView];
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
    return UIEdgeInsetsMake(0, 15, 0, 15);
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
#pragma mark -- subViews
-(void)configSubViews
{
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"common_navgation_right_img") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemClick{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

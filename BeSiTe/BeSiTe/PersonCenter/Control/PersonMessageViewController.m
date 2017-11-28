//
//  PersonMessageViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonMessageViewController.h"
#import "EditNameView.h"
#import "EditPhoneNumberView.h"
#import "EditPassWordView.h"
#import "EditPassWordView.h"
#import "GameItemCollectionViewCell.h"
#import "GamesMenuView.h"

@interface PersonMessageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *mainAccountLab;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *specialVIPImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *phoneStateImageView;
@property (weak, nonatomic) IBOutlet ATNeedBorderButton *phoneEditBtn;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;
@property (weak, nonatomic) IBOutlet UIImageView *emailStateImageView;
@property (weak, nonatomic) IBOutlet ATNeedBorderButton *emailEditBtn;
@property (weak, nonatomic) IBOutlet UIView *collectionTopView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation PersonMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:kGameItemCollectionViewCellReuseID];
    
    _specialVIPImageView.userInteractionEnabled = YES;
    kWeakSelf
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        WebDetailViewController * webVC  = [WebDetailViewController quickCreateWithUrl:[BSTSingle defaultSingle].vipExplainUrl];
        [weak_self pushVC:webVC];
    }];
    [_specialVIPImageView addGestureRecognizer:tap];
}


-(void)getFavGameData
{
    [RequestManager getManagerDataWithPath:@"favGames" params:nil success:^(id JSON) {
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

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    return nil;
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (MAXWIDTH - 60)/3;
    return CGSizeMake(w, w + 20);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(MAXWIDTH, 25);
//}

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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readDataFromSingleLeton];
    [self getFavGameData];

}

-(void)readDataFromSingleLeton
{
    UserModel * user = [BSTSingle defaultSingle].user;
    if (!user)
    {
       
    }
    else
    {
        self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
        self.vipImageView.image = KIMAGE([user getVipImageStr]);
        self.accountNameLab.text = user.accountName;
        self.nameLab.text = user.userName;
        self.phoneLab.text = user.mobile;
        self.phoneStateImageView.image = user.mobileVerified == 0 ? KIMAGE(@"profile_verification_img_false") : KIMAGE(@"profile_verification_img_true");
        [self refreshButton:self.phoneEditBtn state:user.mobileVerified];
        self.emailLab.text = user.email;
        self.emailStateImageView.image = user.emailVerified == 0 ? KIMAGE(@"profile_verification_img_false") : KIMAGE(@"profile_verification_img_true");
        [self refreshButton:self.emailEditBtn state:user.emailVerified];
    }
}

-(void)refreshButton:(UIButton *)button state:(BOOL)isOK{
    button.backgroundColor = isOK ? UIColorFromINTValue(35,160 ,237):UIColorFromINTValue(100,160,88);
    [button setTitle:(isOK ? @"修改": @"验证") forState:UIControlStateNormal];
}

- (IBAction)changePWDBtnClick:(id)sender {
    [EditPassWordView show];
}
- (IBAction)recommendBtnClick:(id)sender {
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

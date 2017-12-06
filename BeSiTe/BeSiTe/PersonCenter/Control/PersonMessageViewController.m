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
#import "RecordExchangeView.h"
#import "EditEmailView.h"

@interface PersonMessageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

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
    
    //展示VIP介绍
    _specialVIPImageView.userInteractionEnabled = YES;
    kWeakSelf
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        WebDetailViewController * webVC  = [WebDetailViewController quickCreateWithUrl:[BSTSingle defaultSingle].vipExplainUrl];
        [weak_self pushVC:webVC];
    }];
    [_specialVIPImageView addGestureRecognizer:tap];
}

#pragma mark -- 界面显示时，读取单例中的个人信息，获取收藏的游戏
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
        self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
        self.vipImageView.image = KIMAGE(@"common_VIP-0");
        self.accountNameLab.text = @"未登录";

        self.nameLab.text = @"";
        self.nameLab.userInteractionEnabled = NO;
        self.nameLab.delegate = nil;
        
        self.phoneLab.text = @"";
        self.phoneStateImageView.image = nil;
        self.phoneEditBtn.hidden = YES;
        self.emailLab.text = @"";
        self.emailStateImageView.image = nil;
        self.emailEditBtn.hidden = YES;
    }
    else
    {
        self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
        self.vipImageView.image = KIMAGE([user getVipImageStr]);
        self.accountNameLab.text = user.accountName;
        if (user.userName.length <= 0) {
            self.nameLab.userInteractionEnabled = YES;
            self.nameLab.text = @"";
            self.nameLab.delegate = self;
        }else{
            self.nameLab.text = user.userName;
            self.nameLab.userInteractionEnabled = NO;
            self.nameLab.delegate = nil;
        }
        
        self.phoneEditBtn.hidden = NO;
        self.emailEditBtn.hidden = NO;
        self.phoneLab.text = user.mobile;
        self.phoneStateImageView.image = user.mobileVerified == 0 ? KIMAGE(@"profile_verification_img_false") : KIMAGE(@"profile_verification_img_true");
        if (user.mobile.length <= 0) {
            [self refreshButton:self.phoneEditBtn state:NO];

        }else{
            [self refreshButton:self.phoneEditBtn state:user.mobileVerified];
        }
        self.emailLab.text = user.email;
        self.emailStateImageView.image = user.emailVerified == 0 ? KIMAGE(@"profile_verification_img_false") : KIMAGE(@"profile_verification_img_true");
        if (user.email.length <= 0) {
            [self refreshButton:self.emailEditBtn state:NO];
        }else{
            [self refreshButton:self.emailEditBtn state:user.emailVerified];
        }
    }
}

-(void)refreshButton:(UIButton *)button state:(BOOL)isOK{
    button.backgroundColor = isOK ? UIColorFromINTValue(35,160 ,237):UIColorFromINTValue(100,160,88);
    [button setTitle:(isOK ? @"修改": @"验证") forState:UIControlStateNormal];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.nameLab) {
        kWeakSelf
        [EditNameView showWithFinshBlock:^{
            [weak_self readDataFromSingleLeton];
        }];
        return NO;
    }
    return YES;
}

-(void)getFavGameData
{
    [RequestManager getManagerDataWithPath:@"favGames" params:nil success:^(id JSON ,BOOL isSuccess) {
        NSLog(@"%@",JSON);
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
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
    kWeakSelf
    [cell setCanCancelCollecWithFinishBlock:^{
        [weak_self getFavGameData];
    }];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [GamesMenuView showWithModel:self.dataSource[indexPath.item]];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (MAXWIDTH - 60)/3;
    return CGSizeMake(w, w + 20);
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
#pragma mark -- Buttons Events
//修改密码
- (IBAction)changePWDBtnClick:(id)sender {
    [EditPassWordView show];
}
//推荐有礼
- (IBAction)recommendBtnClick:(id)sender {
    //暂无功能
}
//修改、验证手机号码
- (IBAction)phoneEditBtnClick:(UIButton *)sender {
//    @"修改": @"验证"
    if ([sender.titleLabel.text isEqualToString:@"修改"]) {
        [EditPhoneNumberView showWithEditPhoneType:EditPhoneNumberViewTypeEdit];
    }else{
        [EditPhoneNumberView showWithEditPhoneType:EditPhoneNumberViewTypeVerify];
    }
}
//修改、验证邮箱
- (IBAction)emailEditBtnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"修改"]) {
        [EditEmailView showWithFinshBlock:^{
            
        }];
    }else{
        [self verifyEmail];
    }
}

-(void)verifyEmail
{
    NSDictionary * dict  = @{@"type":@"2",
                             @"validateParam":self.emailLab.text};
    [RequestManager postWithPath:@"verify" params:dict success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"验证信息发送成功";
        view.msgDetail = @"请登录您的邮箱进行验证。";
        [view showInWindow];
    } failure:^(NSError *error) {
        
    }];
}
//积分兑换
- (IBAction)recordExchangeBtnClick:(id)sender {
    [RecordExchangeView showWithFinshBlock:nil];
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

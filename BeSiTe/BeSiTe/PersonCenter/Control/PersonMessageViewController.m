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

@interface PersonMessageViewController ()
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

@end

@implementation PersonMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFavGameData];
}


-(void)getFavGameData{
    [RequestManager getWithPath:@"getFavGames" params:nil success:^(id JSON) {
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readDataFromSingleLeton];
}

-(void)readDataFromSingleLeton{
   UserModel * user = [BSTSingle defaultSingle].user;

    self.mainAccountLab.attributedText = [UserModel getTotalMoneyAttributeString];
    self.vipImageView.image = KIMAGE([user getVipImageStr]);
    self.accountNameLab.text = user.userName;
    self.nameLab.text = user.userName;
    self.phoneLab.text = user.mobile;
    self.phoneStateImageView.image = user.mobileVerified == 0 ? KIMAGE(@"profile_verification_img_false") : KIMAGE(@"profile_verification_img_true");
    [self refreshButton:self.phoneEditBtn state:user.mobileVerified];
    self.emailLab.text = user.email;
    self.emailStateImageView.image = user.emailVerified == 0 ? KIMAGE(@"profile_verification_img_false") : KIMAGE(@"profile_verification_img_true");
    [self refreshButton:self.emailEditBtn state:user.emailVerified];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

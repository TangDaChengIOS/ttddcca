//
//  GamesMenuView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GamesMenuView.h"
#import "XHStarRateView.h"
#import "AppDelegate+Setting.h"
#import "LoginViewController.h"

@interface GamesMenuView ()

@property (weak, nonatomic) IBOutlet UIView *transView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;//彩色底图
@property (weak, nonatomic) IBOutlet UIView *msgBackView;//信息展示区域白底
@property (weak, nonatomic) IBOutlet UIImageView *gameImageView;//游戏图标
@property (weak, nonatomic) IBOutlet UILabel *gameTitle;//游戏标题
@property (weak, nonatomic) IBOutlet UIView *StarViewContainer;
@property (strong, nonatomic) XHStarRateView *starView;//游戏星级
@property (weak, nonatomic) IBOutlet UIButton *tryPlayBtn;//试玩按钮
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *enterGameBtn;//进入游戏按钮
@property (weak, nonatomic) IBOutlet UIImageView *gameTypeImageView;//最热、最新

@end

@implementation GamesMenuView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    kWeakSelf
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.5 animations:^{
            weak_self.alpha = 0.01;
        } completion:^(BOOL finished) {
            [weak_self removeFromSuperview];
        }];
    }];
    [self.transView addGestureRecognizer:tap];
    
    self.backImageView.userInteractionEnabled = YES;
    CGRect frame = self.StarViewContainer.frame;
    self.starView = [[XHStarRateView alloc]initWithFrame:frame numberOfStars:5 rateStyle:IncompleteStar isAnination:YES delegate:nil];
    self.starView.userInteractionEnabled = NO;
    [self.starView setCurrentScore:self.model.star];
    [self.msgBackView addSubview:self.starView];
}

-(void)setModel:(GamesModel *)model
{
    _model = model;
    [self.gameImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:KIMAGE(@"commmon_home_history")];
    self.gameTitle.text = model.gameName;
    if (model.isTry) {
        [self.tryPlayBtn setTitle:@"试玩" forState:UIControlStateNormal];
    }else{
        [self.tryPlayBtn setTitle:@"收藏" forState:UIControlStateNormal];

    }
    if (model.isFav) {
        [self.collectBtn setImage:KIMAGE_Ori(@"home_collection_select_icon") forState:UIControlStateNormal];
        if (!model.isTry) {
            [self.tryPlayBtn setTitle:@"已收藏" forState:UIControlStateNormal];

        }
    }
    self.gameTypeImageView.image =  [model getTypeImage];
}

#pragma mark -- 试玩 or 收藏
- (IBAction)tryPlayBtnClick:(id)sender
{
    if (self.model.isTry)
    {
        if ([self.model.companyCode isEqualToString:@"PT"]) {
            [[AppDelegate getBoomNavigation] pushViewController:[WebDetailViewController quickCreateGamePageWithUrl:self.model.tryUrl andTitle:self.model.gameName] animated:YES];
            [self removeFromSuperview];
        }else{
            [self requestGameUrlIsTry:YES];
        }

    }else{
        [self collectBtnClick:nil];
    }
}
#pragma mark -- 收藏
- (IBAction)collectBtnClick:(id)sender
{
    if (![BSTSingle defaultSingle].user) {
        [self removeFromSuperview];
        [LoginViewController presentLoginViewController];
        return;
    }
    if (self.model.isFav) {
        TTAlert(@"您已收藏该游戏！");
        return;
    }
    NSDictionary * dict = @{@"gameCode":self.model.gameCode,
                            @"action":@"1",
                            @"gamePlatformCode":self.model.companyCode};
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"favGame" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        TTAlert(@"收藏成功！");
        weak_self.model.isFav = YES;
        [weak_self.model refreshCaches];
        [weak_self.collectBtn setImage:KIMAGE_Ori(@"home_collection_select_icon") forState:UIControlStateNormal];
        if (!weak_self.model.isTry) {
            [weak_self.tryPlayBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
    }];
}
#pragma mark -- 进入游戏
- (IBAction)enterGameClick:(id)sender {
    if (![BSTSingle defaultSingle].user) {
        [self removeFromSuperview];
        [LoginViewController presentLoginViewController];
        return;
    }
    if ([self.model.companyCode isEqualToString:@"PT"]) {
        NSString * url = [self addParaToUrl:self.model.gameUrl];
        [[AppDelegate getBoomNavigation] pushViewController:[WebDetailViewController quickCreateGamePageWithUrl:url andTitle:self.model.gameName] animated:YES];
        [self removeFromSuperview];
    }else{
        [self requestGameUrlIsTry:NO];
    }
}

-(NSString *)addParaToUrl:(NSString *)sourceUrl
{
    if ([self string:sourceUrl isHaveCharacter:'?']) {
        return [sourceUrl stringByAppendingString:[NSString stringWithFormat:@"&loginName=%@",[BSTSingle defaultSingle].user.accountName]];
    }else{
        return [sourceUrl stringByAppendingString:[NSString stringWithFormat:@"?loginName=%@",[BSTSingle defaultSingle].user.accountName]];

    }
}

-(BOOL)string:(NSString *)string isHaveCharacter:(char)ch
{
    for (int i = 0; i < string.length; i++) {
        char child = [string characterAtIndex:i];
        if (ch == child) {
            return YES;
        }
    }
    return NO;
}


-(void)requestGameUrlIsTry:(BOOL)isTry
{
//    gamePlatformCode	string	是	游戏平台CODE
//    gameCode	string	是	游戏CODE
//    type	string	是	1:正式2:试玩

    NSString * type = isTry ? @"2":@"1";
    NSDictionary * dict = @{@"gamePlatformCode":self.model.companyCode,
                            @"gameCode":self.model.gameCode,
                            @"type":type};
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"gameLogin" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [[AppDelegate getBoomNavigation] pushViewController:[WebDetailViewController quickCreateGamePageWithUrl:JSON[@"gameUrl"] andTitle:weak_self.model.gameName] animated:YES];
        [weak_self removeFromSuperview];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
    }];
}


+(void)showWithModel:(GamesModel *)model{
    if (!model) {
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    GamesMenuView * view = [[[NSBundle mainBundle]loadNibNamed:@"GamesMenuView" owner:self options:nil] firstObject];
    view.frame = window.bounds;
    view.model = model;
    [window addSubview:view];
}


@end

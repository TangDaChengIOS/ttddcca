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
    self.starView = [[XHStarRateView alloc]initWithFrame:frame numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:nil];
    self.starView.userInteractionEnabled = NO;
    [self.msgBackView addSubview:self.starView];
    
    self.starView.currentScore = 3;
}

-(void)setModel:(GamesModel *)model
{
    _model = model;
    [self.gameImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:nil];
    self.gameTitle.text = model.gameName;
    if (model.isTry) {
        [self.tryPlayBtn setTitle:@"试玩" forState:UIControlStateNormal];
    }else{
        [self.tryPlayBtn setTitle:@"收藏" forState:UIControlStateNormal];

    }
    self.gameTypeImageView.image =  [model getTypeImage];
}

#pragma mark -- 试玩 or 收藏
- (IBAction)tryPlayBtnClick:(id)sender
{
    if (self.model.isTry) {
        [[AppDelegate getBoomNavigation] pushViewController:[WebDetailViewController quickCreateGamePageWithUrl:self.model.tryUrl] animated:YES];
        [self removeFromSuperview];
    }else{
        [self collectBtnClick:nil];
    }
}
#pragma mark -- 收藏
- (IBAction)collectBtnClick:(id)sender
{
    NSDictionary * dict = @{@"gameCode":self.model.gameCode,
                            @"action":@"1",
                            @"gamePlatformCode":self.model.companyCode};
    [RequestManager postWithPath:@"favGame" params:dict success:^(id JSON) {
        TTAlert(@"收藏成功！");
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 进入游戏
- (IBAction)enterGameClick:(id)sender {
    [[AppDelegate getBoomNavigation] pushViewController:[WebDetailViewController quickCreateGamePageWithUrl:self.model.gameUrl] animated:YES];
    [self removeFromSuperview];
}

+(void)showWithModel:(GamesModel *)model{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    GamesMenuView * view = [[[NSBundle mainBundle]loadNibNamed:@"GamesMenuView" owner:self options:nil] firstObject];
    view.frame = window.bounds;
    view.model = model;
    [window addSubview:view];
}


@end

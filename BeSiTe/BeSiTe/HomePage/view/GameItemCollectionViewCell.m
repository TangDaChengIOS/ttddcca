//
//  GameItemCollectionViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameItemCollectionViewCell.h"

@interface GameItemCollectionViewCell ()<UIAlertViewDelegate>
@property (nonatomic,strong) UIImageView * mainImage;
@property (nonatomic,strong) UILabel * boomLab;
@property (nonatomic,strong) GamesModel * model;
@property (nonatomic,strong) UILongPressGestureRecognizer * longPressGes;
@property (nonatomic,copy) void (^finishCancelCollectBlock)();
@end

@implementation GameItemCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
        _mainImage.image = KIMAGE(@"home_tab_PNGType_img");
        [self.contentView addSubview:_mainImage];
        
        _boomLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _mainImage.maxY, frame.size.width, 20)];
        _boomLab.textColor = UIColorFromINTValue(45, 45, 45);
        _boomLab.font = kFont(12);
        _boomLab.backgroundColor = UIColorFromINTValue(242, 240, 241);
        _boomLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_boomLab];
    }
    return self;
}


-(void)setCellWithModel:(GamesModel *)model{
    _model = model;
    [_mainImage setImageWithURL:[NSURL URLWithString:model.icon] placeholder:KIMAGE(@"commmon_home_history")];
    _boomLab.text = model.gameName;
    self.contentView.gestureRecognizers = nil;
}

-(UILongPressGestureRecognizer *)longPressGes
{
    if (!_longPressGes) {
        _longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    }
    return _longPressGes;
}

-(void)longPress:(UILongPressGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        NSString * string = [NSString stringWithFormat:@"确定要取消收藏“%@”么？",self.model.gameName];
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary * dict = @{@"gameCode":self.model.gameCode,
                                @"action":@"2",
                                @"gamePlatformCode":self.model.companyCode};
        kWeakSelf
        [RequestManager postWithPath:@"favGame" params:dict success:^(id JSON ,BOOL isSuccess) {
            if (!isSuccess) {
                TTAlert(JSON);
                return ;
            }
            TTAlert(@"取消收藏成功！");
            if (weak_self.finishCancelCollectBlock) {
                weak_self.finishCancelCollectBlock();
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)setCanCancelCollecWithFinishBlock:(void (^)())finishCancel
{
    [self.contentView addGestureRecognizer:self.longPressGes];
    self.finishCancelCollectBlock = finishCancel;
}


@end

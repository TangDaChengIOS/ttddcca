//
//  GamesCanScrollTipsView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/12.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GamesCanScrollTipsView.h"

@interface GamesCanScrollTipsView ()
@property (nonatomic,strong) UIImageView * moveImageView;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) BOOL isAddToSuperView;
@end

@implementation GamesCanScrollTipsView


-(instancetype)init{
    if (self =[super init]) {
        self.frame = CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        UIView * _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT)];
        _contentView.backgroundColor = UIColorFromINTRGBA(0, 0, 0, 0.4);
        [self addSubview:_contentView];
    
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH - 68 - 35, MAXHEIGHT / 2 - 66, 45, 132)];
        imageView.image = KIMAGE(@"home_reflase_top_img");
        [self addSubview:imageView];
        
        _moveImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH - 80, MAXHEIGHT / 2 + 66, 70, 60)];
        _moveImageView.image = KIMAGE(@"home_finger_image");
        [self addSubview:_moveImageView];
        
        kWeakSelf
        UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weak_self removeSelf];

        }];
        swip.direction = UISwipeGestureRecognizerDirectionUp;
        [_contentView addGestureRecognizer:swip];
        
    }
    return self;
}

-(void)didMoveToWindow
{
    [super didMoveToWindow];
    if (!self.isAddToSuperView) {
        self.isAddToSuperView = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timeIsRunning) userInfo:nil repeats:YES];
    }
}

-(void)timeIsRunning
{
    [UIView animateWithDuration:1 animations:^{
        self.moveImageView.mj_y = MAXHEIGHT / 2 - 80;
    } completion:^(BOOL finished) {
        self.moveImageView.mj_y = MAXHEIGHT / 2 + 66;
    }];
}

-(void)removeSelf{
    [_timer invalidate];
    _timer = nil;
    [self removeFromSuperview];
    if (self.completeBlock) {
        self.completeBlock();
    }
}

+(void)showWithFinshBlock:(void (^)())completeBlock{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    GamesCanScrollTipsView * view = [[GamesCanScrollTipsView alloc]init];
    view.completeBlock = completeBlock;
    [window addSubview:view];
}

@end

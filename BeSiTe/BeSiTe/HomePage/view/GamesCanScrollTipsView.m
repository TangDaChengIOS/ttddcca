//
//  GamesCanScrollTipsView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/12.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GamesCanScrollTipsView.h"

@implementation GamesCanScrollTipsView


-(instancetype)init{
    if (self =[super init]) {
        self.frame = CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        UIView * _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT)];
        _contentView.backgroundColor = UIColorFromINTRGBA(0, 0, 0, 0.4);
        [self addSubview:_contentView];
    
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH - 92, MAXHEIGHT / 2 - 66, 86, 132)];
        imageView.image = KIMAGE(@"home_reflase_top_img");
        [self addSubview:imageView];
        
        kWeakSelf
        UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weak_self removeSelf];

        }];
        swip.direction = UISwipeGestureRecognizerDirectionUp;
        [_contentView addGestureRecognizer:swip];
        
    }
    return self;
}

-(void)removeSelf{
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

//
//  GamesMenuView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GamesMenuView.h"
#import "XHStarRateView.h"

@interface GamesMenuView ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *msgBackView;
@property (weak, nonatomic) IBOutlet UIImageView *gameImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet XHStarRateView *starView;
@property (weak, nonatomic) IBOutlet UIButton *tryPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *enterGameBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gameTypeImageView;

@end

@implementation GamesMenuView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        kWeakSelf
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weak_self removeFromSuperview];
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (IBAction)tryPlayBtnClick:(id)sender {
    [self removeFromSuperview];
    if (self.tryPlayBlock) {
        self.tryPlayBlock();
    }
}
- (IBAction)collectBtnClick:(id)sender {
}
- (IBAction)enterGameClick:(id)sender {
}

+(void)show{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    GamesMenuView * view = [[[NSBundle mainBundle]loadNibNamed:@"GamesMenuView" owner:self options:nil] firstObject];
    view.frame = window.bounds;
    [window addSubview:view];
}


@end

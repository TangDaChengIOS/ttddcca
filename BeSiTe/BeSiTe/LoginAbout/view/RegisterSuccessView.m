//
//  RegisterSuccessView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RegisterSuccessView.h"

@interface RegisterSuccessView ()
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *deailMsgLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *onlyOneBtn;

@end

@implementation RegisterSuccessView

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

- (IBAction)leftBtnDidClicked:(id)sender {
    self.showType -= 1;
}
- (IBAction)rightBtnDidClicked:(id)sender {
    self.showType += 1;

}
- (IBAction)onlyOneBtnDidClicked:(id)sender {
    self.showType -= 1;

}

-(void)setShowType:(ShowType)showType
{
    _showType = showType;

    switch (_showType) {
        case ShowTypeWaitThreeSec:{
            _timeLab.hidden = NO;
            _leftBtn.hidden = _rightBtn.hidden = _onlyOneBtn.hidden = !_timeLab.hidden;
        }
          break;
        case ShowTypeWaitThreeSec_TLD:{
            _timeLab.hidden = NO;
            _leftBtn.hidden = _rightBtn.hidden = _onlyOneBtn.hidden = !_timeLab.hidden;
        }
            break;
        case ShowTypeShowTwoSel:{
            _leftBtn.hidden = _rightBtn.hidden = NO;
            _onlyOneBtn.hidden = _timeLab.hidden = YES;
        }
            break;
        case ShowTypeShowOneSel:{
            _leftBtn.hidden = _rightBtn.hidden = _timeLab.hidden = YES;
            _onlyOneBtn.hidden  = NO;
        }
            break;
        default:
            break;
    }
}

+(void)show{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    RegisterSuccessView * view = [[[NSBundle mainBundle]loadNibNamed:@"RegisterSuccessView" owner:self options:nil] firstObject];
    view.frame = window.bounds;
    view.showType = 2;
    [window addSubview:view];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    _leftBtn.layer.cornerRadius = _rightBtn.layer.cornerRadius = _onlyOneBtn.layer.cornerRadius = 4.0f;

//    UIColorFromRGBValue(0xffffff);
//    UIColorFromINTValue(255, 255, 255);
}

@end

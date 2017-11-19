//
//  RegisterSuccessView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BSTMessageView.h"

@interface BSTMessageView (){
    NSTimer * _timer;
}
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *deailMsgLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *onlyOneBtn;

@property (nonatomic,assign) NSInteger maxWaitSeconds;

@end

@implementation BSTMessageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        kWeakSelf
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (!weak_self.isNotAllowRemoveSelfByTouchSpace) {
                [weak_self removeFromSuperview];
            }
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (IBAction)leftBtnDidClicked:(id)sender {
    if (self.eventBlock) {
        self.eventBlock(EventTypeLeftBtnClick);
        [self removeFromSuperview];
    }
}
- (IBAction)rightBtnDidClicked:(id)sender {
    if (self.eventBlock) {
        self.eventBlock(EventTypeRightBtnClick);
        [self removeFromSuperview];
    }
}
- (IBAction)onlyOneBtnDidClicked:(id)sender {
    if (self.eventBlock) {
        self.eventBlock(EventTypeLeftBtnClick);
        [self removeFromSuperview];
    }
}

-(void)setShowType:(ShowType)showType
{
    _showType = showType;

    switch (_showType) {
        case ShowTypeWaitThreeSec:{
            _timeLab.hidden = NO;
            _leftBtn.hidden = _rightBtn.hidden = _onlyOneBtn.hidden = !_timeLab.hidden;
            _maxWaitSeconds = 4;
            self.timeLab.text = [NSString stringWithFormat:@"%lds",self.maxWaitSeconds];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitThirdSec) userInfo:nil repeats:YES];

            [self waitThirdSec];
        }
          break;
        case ShowTypeWaitThreeSec_TLD:{
            _timeLab.hidden = NO;
            _leftBtn.hidden = _rightBtn.hidden = _onlyOneBtn.hidden = !_timeLab.hidden;
            _maxWaitSeconds = 4;
            self.timeLab.text = [NSString stringWithFormat:@"%lds",self.maxWaitSeconds];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitThirdSec) userInfo:nil repeats:YES];

            [self waitThirdSec];
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

+(void)showView:(ShowType)showType{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
    view.frame = window.bounds;
    view.showType = showType;
    [window addSubview:view];
}

-(void)showInWindow{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    [window addSubview:self];
}


-(void)setLeftBtnTitle:(NSString *)leftBtnTitle
{
    _leftBtnTitle = leftBtnTitle;
    [self.leftBtn setTitle:_leftBtnTitle forState:UIControlStateNormal];
}
-(void)setRightBtnTitle:(NSString *)rightBtnTitle
{
    _rightBtnTitle = rightBtnTitle;
    [self.rightBtn setTitle:_rightBtnTitle forState:UIControlStateNormal];
}

-(void)setOnlyOneBtnTitle:(NSString *)onlyOneBtnTitle
{
    _onlyOneBtnTitle = onlyOneBtnTitle;
    [self.onlyOneBtn setTitle:_onlyOneBtnTitle forState:UIControlStateNormal];
}
-(void)setMsgTitle:(NSString *)msgTitle
{
    _msgTitle = msgTitle;
    self.titleLab.text = msgTitle;
}
-(void)setMsgDetail:(NSString *)msgDetail
{
    _msgDetail = msgDetail;
    self.deailMsgLab.text = msgDetail;
}
-(void)setIsSuccessMsg:(BOOL)isSuccessMsg
{
    _isSuccessMsg = isSuccessMsg;
    self.stateImageView.image = _isSuccessMsg ? KIMAGE(@"common_message_success_icon"):KIMAGE(@"common_error_icon");
}

-(void)setIsNotAllowRemoveSelfByTouchSpace:(BOOL)isNotAllowRemoveSelfByTouchSpace
{
    _isNotAllowRemoveSelfByTouchSpace = isNotAllowRemoveSelfByTouchSpace;
}


-(void)waitThirdSec
{
    self.maxWaitSeconds -- ;
    self.timeLab.text = [NSString stringWithFormat:@"%lds",self.maxWaitSeconds];
    if (self.maxWaitSeconds <= 0) {
        [_timer invalidate];
        [self removeFromSuperview];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _leftBtn.layer.cornerRadius = _rightBtn.layer.cornerRadius = _onlyOneBtn.layer.cornerRadius = 4.0f;

//    UIColorFromRGBValue(0xffffff);
//    UIColorFromINTValue(255, 255, 255);
}

@end

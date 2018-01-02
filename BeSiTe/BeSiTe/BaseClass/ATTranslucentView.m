//
//  ATTranslucentView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface ATTranslucentView (){
    BOOL _isKeyBoardShow;
    CGFloat _whiteBack_originY;//底白的实际Y轴坐标
}
@property (nonatomic,strong) UIView * contentView;

@end

@implementation ATTranslucentView

-(instancetype)init{
    if (self =[super init]) {
        self.frame = CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT);
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT)];
        _contentView.backgroundColor = UIColorFromINTRGBA(0, 0, 0, 0.4);
        [self addSubview:_contentView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
    
        kWeakSelf
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (_isKeyBoardShow) {
                [weak_self endEditing:YES];
            }
            else{
                [weak_self removeSelf];
            }
        }];
        [_contentView addGestureRecognizer:tap];
        
        whiteBack = [[UIView alloc]initWithFrame:CGRectZero];
        whiteBack.backgroundColor = kWhiteColor;
        whiteBack.layer.cornerRadius = 4;
        [self addSubview:whiteBack];
        
        UITapGestureRecognizer * whiteBackTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (_isKeyBoardShow) {
                [weak_self endEditing:YES];
            }
        }];
        [whiteBack addGestureRecognizer:whiteBackTap];
    }
    return self;
}
-(void)didMoveToSuperview{
    _whiteBack_originY = whiteBack.mj_y;
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)removeSelf{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [IQKeyboardManager sharedManager].enable = YES;
    [self removeFromSuperview];
}

#pragma mark -- 键盘事件
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    _isKeyBoardShow = YES;

    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyBoardH = keyboardRect.size.height;
    [self resetUIWithOffsetY:keyBoardH];
}

-(void)keyboardWillHidden
{
    _isKeyBoardShow = NO;
    [self resetUIWithOffsetY:0];
}
-(void)resetUIWithOffsetY:(CGFloat)offsetY
{
    NSLog(@"___offset:%lf___MAX:%lf___H:%lf",offsetY,MAXHEIGHT,whiteBack.mj_h);
    if (MAXHEIGHT - whiteBack.maxY < offsetY ) {
        whiteBack.mj_y = MAXHEIGHT - whiteBack.mj_h - offsetY - 5;
    }else{
        if (offsetY <= 0) {
            whiteBack.mj_y = _whiteBack_originY;
        }
    }
    [self layoutIfNeeded];
}

-(UITextField *)createTextFieldWithFrame:(CGRect)frame{
    //手机号码输入
    UITextField * phoneTF = [[UITextField alloc]initWithFrame:frame];
    phoneTF.layer.borderColor = UIColorFromRGBValue(0xc9c9c9).CGColor;
    phoneTF.layer.borderWidth = 1.0f;
    phoneTF.layer.cornerRadius = 4.0f;
    phoneTF.font = kFont(15);
    phoneTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 1)];
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    return phoneTF;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

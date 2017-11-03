//
//  ATTranslucentView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"

@interface ATTranslucentView (){
    BOOL _isKeyBoardShow;
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
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardDidHideNotification object:nil];

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
        
    }
    return self;
}

-(void)removeSelf{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self removeFromSuperview];
}

-(void)keyboardShow{
    _isKeyBoardShow = YES;
}

-(void)keyboardHidden{
    _isKeyBoardShow = NO;
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

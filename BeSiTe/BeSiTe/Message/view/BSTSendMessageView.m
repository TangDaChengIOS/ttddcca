//
//  BSTSendMessageView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BSTSendMessageView.h"

@interface BSTSendMessageView ()<UITextViewDelegate>{
    CGFloat _originY;
    CGFloat _originH;
    CGFloat _keyBoardH;
    CGFloat _textViewChangedH;
}


@end

@implementation BSTSendMessageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _originY = frame.origin.y;
        _originH = frame.size.height;
        _keyBoardH = 0;
        _textViewChangedH = 0;
        
        self.backgroundColor = UIColorFromINTValue(244, 244, 244);
        self.layer.borderColor = UIColorFromINTValue(220, 220, 220).CGColor;
        self.layer.borderWidth = 1.0f;
        
        _textView = [[UITextView alloc]init];
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = UIColorFromINTValue(220, 220, 220).CGColor;
        _textView.layer.borderWidth = 1.0f;
        _textView.font = kFont(14);
        _textView.delegate = self;
        _textView.text = @"说点什么...";
        [self addSubview:_textView];
        
        _sendBtn = [[UIButton alloc]init];
        _sendBtn.backgroundColor = UIColorFromRGBValue(0x19A967);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 4.0f;
        [self addSubview:_sendBtn];
        
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(@10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(_sendBtn.mas_left).offset(-10);
        }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

#pragma mark -- TextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"说点什么..."]) {
        textView.text = @"";
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        textView.text = @"说点什么...";
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat height = textView.contentSize.height;
    CGFloat minHeight = _originH - 20 ;
    CGFloat maxHeight= minHeight * 2;
    
    if (height < minHeight) {
        height = minHeight;
    }else if (height > maxHeight){
        height = maxHeight;
    }
    _textViewChangedH = height - minHeight;
    [self resetUI];
}

#pragma mark -- 键盘事件
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardH = keyboardRect.size.height;
    [self resetUI];
}

-(void)keyboardWillHidden
{
    _keyBoardH = 0;
    [self resetUI];
}

-(void)resetUI{
    self.mj_y = _originY - _textViewChangedH - _keyBoardH;
    self.mj_h = _originH + _textViewChangedH;
    [self layoutIfNeeded];
}


-(void)setDefaultUI{
    self.textView.text = @"";
    _keyBoardH = 0;
    _textViewChangedH = 0;
    [self resetUI];
}


-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end

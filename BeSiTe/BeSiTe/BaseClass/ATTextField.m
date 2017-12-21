//
//  ATTextField.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/1.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTextField.h"

@implementation ATTextField

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = UIColorFromINTValue(205, 205, 205).CGColor;
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 0.5;
    self.borderStyle = UITextBorderStyleNone;
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 1)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIKeyboardType type = self.keyboardType;

    if(action == @selector(paste:) && type == UIKeyboardTypeNumberPad){//禁止粘贴
        return NO;
    }
    
    //    if(action == @selector(select:)){// 禁止选择
    //        return NO;
    //    }
    //
    //    if(action == @selector(selectAll:)){// 禁止全选
    //        return NO;
    //    }
    
    return [super canPerformAction:action withSender:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

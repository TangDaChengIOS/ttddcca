//
//  NoPasteTextField.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/18.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "NoPasteTextField.h"

@implementation NoPasteTextField


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(paste:)){//禁止粘贴
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
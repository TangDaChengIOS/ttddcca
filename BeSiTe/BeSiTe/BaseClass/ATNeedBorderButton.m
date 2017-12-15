//
//  ATNeedBorderButton.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATNeedBorderButton.h"

@implementation ATNeedBorderButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 0.5;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 0.5;
    }
    return self;
}

@end

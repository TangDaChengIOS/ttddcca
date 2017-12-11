//
//  BSTNoDataView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BSTNoDataView.h"

@interface BSTNoDataView ()
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * tipsLab;
@end

@implementation BSTNoDataView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configSubViews];
    }
    return self;
}

-(void)setIsMsg:(BOOL)isMsg
{
    _isMsg = isMsg;
    if (isMsg) {
        _tipsLab.text = @"暂无消息";
        _imageView.top = 90;

    }else{
        _tipsLab.text = @"暂无数据";
        _imageView.top = 30;
    }
    _tipsLab.top = _imageView.maxY + 5;
}


-(void)configSubViews{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH /2 - 30, 30, 60, 50)];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = KIMAGE(@"home_message_default_img");
    [self addSubview:_imageView];
    
    _tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(MAXWIDTH / 2 - 100, 85, 200, 16)];
    _tipsLab.textColor = UIColorFromINTValue(215, 215, 215);
    _tipsLab.font = kFont(12);
    _tipsLab.textAlignment = NSTextAlignmentCenter;
    _tipsLab.text = @"暂无消息";
    [self addSubview:_tipsLab];
    

}


@end

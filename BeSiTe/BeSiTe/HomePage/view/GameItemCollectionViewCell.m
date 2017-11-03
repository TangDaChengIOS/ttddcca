//
//  GameItemCollectionViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameItemCollectionViewCell.h"

@interface GameItemCollectionViewCell ()
@property (nonatomic,strong) UIImageView * mainImage;
@property (nonatomic,strong) UILabel * boomLab;
@end

@implementation GameItemCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
        _mainImage.image = KIMAGE(@"home_tab_PNGType_img");
        [self.contentView addSubview:_mainImage];
        
        _boomLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _mainImage.maxY, frame.size.width, 20)];
        _boomLab.textColor = UIColorFromINTValue(45, 45, 45);
        _boomLab.font = kFont(12);
        _boomLab.backgroundColor = UIColorFromINTValue(242, 240, 241);
        _boomLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_boomLab];
    }
    return self;
}


-(void)setCell{
    _boomLab.text = @"扑鱼达人";
}


@end

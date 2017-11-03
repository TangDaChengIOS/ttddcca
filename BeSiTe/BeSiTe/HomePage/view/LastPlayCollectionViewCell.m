//
//  LastPlayCollectionViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/21.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "LastPlayCollectionViewCell.h"

@interface LastPlayCollectionViewCell ()
@property (nonatomic,strong) UIImageView * mainImage;
@property (nonatomic,strong) UIImageView * typeImage;
@end

@implementation LastPlayCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _mainImage = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
//        _mainImage.image = KIMAGE(@"home_tab_PNGType_img");
        [self.contentView addSubview:_mainImage];
        
        _typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 30, 0, 30, 30)];
//        _typeImage.image = KIMAGE(@"home_activity_hot_icon");
        [self.contentView addSubview:_typeImage];
    }
    return self;
}

-(void)setCellWithModel:(GamesModel *)model{
    [_mainImage setImageWithURL:[NSURL URLWithString:model.icon] placeholder:KIMAGE(@"home_tab_PNGType_img")];
//    _typeImage.image = KIMAGE(@"home_activity_hot_icon");
}

@end

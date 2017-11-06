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
@property (nonatomic,assign) BOOL isMenuItem;
@property (nonatomic,strong) GamesCompanyModel * model;
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
    _isMenuItem = NO;
    [_mainImage setImageWithURL:[NSURL URLWithString:model.icon] placeholder:KIMAGE(@"home_tab_PNGType_img")];
    
    if (model.isHot) {
        _typeImage.image = KIMAGE(@"home_activity_hot_icon");
    }
    else{
        if (model.isNew) {
            _typeImage.image = KIMAGE(@"home_game_platform_new_icon");
        }
        else{
            _typeImage.image = nil;
        }
    }
}

-(void)setCellWithCompanyModel:(GamesCompanyModel *)model{
    _isMenuItem = YES;
    _model = model;
    [_mainImage setImageWithURL:[NSURL URLWithString:model.classIcon] placeholder:KIMAGE(@"home_tab_PNGType_img")];
    
    if (model.isHot) {
        _typeImage.image = KIMAGE(@"home_activity_hot_icon");
    }
    else{
        if (model.isNew) {
            _typeImage.image = KIMAGE(@"home_game_platform_new_icon");
        }
        else{
            _typeImage.image = nil;
        }
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (self.isMenuItem) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainImage setImageWithURL:[NSURL URLWithString:selected ? self.model.classIconSel : self.model.classIcon] placeholder:KIMAGE(@"home_tab_PNGType_img")];
 
        });
    }
}

@end

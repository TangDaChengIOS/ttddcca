//
//  HomeItemCollectionViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/21.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "HomeItemCollectionViewCell.h"

@interface HomeItemCollectionViewCell ()
@property (nonatomic,strong) UIImageView * mainImage;
@property (nonatomic,strong) UIImageView * typeImage;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * nodataLab;

@end

@implementation HomeItemCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.backgroundColor = kWhiteColor;
        _mainImage = [[UIImageView alloc]init];
        _mainImage.size = CGSizeMake(62 * kPROPORTION, 62 * kPROPORTION);
        _mainImage.centerX = self.contentView.centerX;
        _mainImage.top = 7 * kPROPORTION;
        [self.contentView addSubview:_mainImage];
        
        CGFloat w = 25 * kPROPORTION;
        _typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - w, 0, w, w)];
        [self.contentView addSubview:_typeImage];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _mainImage.maxY + 10 * kPROPORTION, self.contentView.width, 15 * kPROPORTION)];
        _titleLab.textColor = UIColorFromINTValue(65, 121, 130);
        _titleLab.font = kFont(14);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLab];
        
        _nodataLab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.contentView.height /2 -10 , self.contentView.width, 20)];
        _nodataLab.textColor = UIColorFromINTValue(226, 226, 226);
        _nodataLab.font = kFont(14);
        _nodataLab.text = @"敬请期待";
        _nodataLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nodataLab];
    }
    return self;
}
-(void)setCellWithModel:(GamesCompanyModel *)model
{
    [_mainImage setImageWithURL:[NSURL URLWithString:model.mainIcon] placeholder:KIMAGE(@"commmon_home_history")];
    if (model.isHot) {
        _typeImage.image = KIMAGE(@"home_gameType_hot_img");
    }
    else{
        if (model.isNew) {
            _typeImage.image = KIMAGE(@"home_gameType_new_img");
        }
        else{
            _typeImage.image = nil;
        }
    }
    _titleLab.text = model.companyName;

}

-(void)setItemType:(HomeItemType)itemType
{
    _itemType = itemType;
    BOOL ret;
    if (itemType == HomeItemTypeDefault) {
        self.contentView.backgroundColor = kWhiteColor;
        ret = NO;
    }else{
        self.contentView.backgroundColor = UIColorFromINTValue(241, 241, 241);
        ret = YES;
    }
    _typeImage.hidden = ret;
    _mainImage.hidden = ret;
    _titleLab.hidden = ret;
    _nodataLab.hidden = !ret;
}

@end

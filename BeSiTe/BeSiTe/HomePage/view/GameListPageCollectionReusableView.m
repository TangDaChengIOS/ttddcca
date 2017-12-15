//
//  GameListPageCollectionReusableView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameListPageCollectionReusableView.h"

@interface GameListPageCollectionReusableView ()

@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UILabel * titleLab;

@end

@implementation GameListPageCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 15)];
        _leftImageView.image = KIMAGE(@"home_gameTypeName_icon");
        [self addSubview:_leftImageView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 200, 15)];
        _titleLab.textColor = UIColorFromINTValue(71, 71, 71);
        _titleLab.font = kFont(12);
        [self addSubview:_titleLab];
    }
    return self;
}

-(void)setIsShowResult:(BOOL)isShowResult{
    _isShowResult = isShowResult;
    if (isShowResult) {
        _leftImageView.hidden = YES;
        _titleLab.left = 15;
        self.backgroundColor = UIColorFromINTValue(231, 231, 231);
    }else{
        _leftImageView.hidden = NO ;
        _titleLab.left = _leftImageView.maxX + 3;
        self.backgroundColor = kWhiteColor;
    }
}

-(void)setCellWithCompanyName:(NSString *)companyName andNums:(NSInteger)nums{
    if (_isShowResult) {
        
        NSMutableAttributedString * mAStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@平台游戏款",companyName] attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(71, 71, 71),NSFontAttributeName:kFont(12)}];
        NSAttributedString * mAStr_num = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",nums] attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(255, 0, 0),NSFontAttributeName:kFont(12)}];
        [mAStr insertAttributedString:mAStr_num atIndex:mAStr.length-1];
        _titleLab.attributedText = mAStr;
        
    }else{
        _titleLab.text = [NSString stringWithFormat:@"%@游戏%ld款",companyName,nums];
    }
}


@end

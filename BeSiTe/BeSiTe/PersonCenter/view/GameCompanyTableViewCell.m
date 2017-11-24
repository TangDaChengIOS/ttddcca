//
//  GameCompanyTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameCompanyTableViewCell.h"

@interface GameCompanyTableViewCell ()
@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UILabel * companyNameLab;
@property (nonatomic,strong) GamesCompanyModel * model;

@end

@implementation GameCompanyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 25, 25)];
        [self.contentView addSubview:_leftImageView];
        
        _companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.maxX + 15, 12, 200, 20)];
        _companyNameLab.font = kFont(15);
        _companyNameLab.textColor = kBlackColor;
        [self.contentView addSubview:_companyNameLab];
    }
    return self;
}

-(void)setCellWithCompanyModel:(GamesCompanyModel *)model
{
    _model = model;
    [_leftImageView setImageWithURL:[NSURL URLWithString:model.listIcon] placeholder:nil];
    _companyNameLab.text = model.companyName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

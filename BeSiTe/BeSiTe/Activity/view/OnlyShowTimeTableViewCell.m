//
//  OnlyShowTimeTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "OnlyShowTimeTableViewCell.h"

@interface OnlyShowTimeTableViewCell ()
@property (nonatomic,strong) UILabel * timeLab;
@end
@implementation OnlyShowTimeTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorFromINTValue(230, 230, 230);

//        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAXWIDTH / 2 - 100,10,200 ,18)];
        _timeLab = [[UILabel alloc]init];

        _timeLab.backgroundColor = UIColorFromINTValue(218, 218, 218);
        _timeLab.textColor = kWhiteColor;
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = kFont(10);
        _timeLab.text = @"11月10日 下午10：37";
        _timeLab.layer.cornerRadius = 2.0f;
        [self.contentView addSubview:_timeLab];
    }
    return self;
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

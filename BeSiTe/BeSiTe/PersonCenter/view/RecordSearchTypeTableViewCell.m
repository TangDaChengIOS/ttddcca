//
//  RecordSearchTypeTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RecordSearchTypeTableViewCell.h"

@interface RecordSearchTypeTableViewCell ()

@end
@implementation RecordSearchTypeTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MAXWIDTH / 2 - 100, 7.5, 200, 20)];
        _titleLab.center = self.contentView.center;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font  =kFont(14);

        [self.contentView addSubview:_titleLab];
    }
    return self;
}

-(void)setIsSingleLine:(BOOL)isSingleLine{
    _isSingleLine = isSingleLine;
    self.contentView.backgroundColor = _isSingleLine ? UIColorFromINTValue(238, 236, 237) :UIColorFromINTValue(230, 230, 230);
    _titleLab.textColor = _isSingleLine ? UIColorFromINTValue(120, 120, 120) :UIColorFromINTValue(85, 85, 85);
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

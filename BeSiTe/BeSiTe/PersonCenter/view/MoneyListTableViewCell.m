//
//  MoneyListTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyListTableViewCell.h"

@interface MoneyListTableViewCell ()
@property (nonatomic,strong) UILabel * leftLab;
@property (nonatomic,strong) UILabel * rightLab;
@end

@implementation MoneyListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat labWidth = MAXWIDTH /2 - 12 - 40;
        _leftLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, labWidth, 20)];
        [self.contentView addSubview:_leftLab];
        
        _rightLab = [[UILabel alloc]initWithFrame:CGRectMake(MAXWIDTH /2 -2, 0, labWidth, 20)];
        [self.contentView addSubview:_rightLab];
        
        _leftLab.textAlignment = _rightLab.textAlignment = NSTextAlignmentRight;
        
    }
    return self;
}
-(void)setCellTye:(CellType)cellTye{
    _cellTye = cellTye;
    _leftLab.centerY = _rightLab.centerY = self.contentView.centerY;
    switch (_cellTye) {
        case CellTypeFirstLine:{
            _leftLab.font = _rightLab.font = kFont(15);
            _leftLab.textColor = _rightLab.textColor = UIColorFromINTValue(114, 113, 113);
            }
            break;
        case CellTypeOther:{
            _leftLab.font = _rightLab.font = kFont(12);
            _leftLab.textColor =  UIColorFromINTValue(114, 113, 113);
            _rightLab.textColor = UIColorFromINTValue(0, 146, 0);
        }
            break;
        default:{
            _leftLab.font = _rightLab.font = kFont(12);
            _leftLab.textColor =  UIColorFromINTValue(114, 113, 113);
            _rightLab.textColor = UIColorFromINTValue(0, 146, 0);
        }
            break;
    }
}
-(void)setCell:(NSString *)name money:(NSString *)money whiteBack:(BOOL)isWhite{
    self.contentView.backgroundColor = isWhite ? kWhiteColor :UIColorFromINTValue(248, 246, 247);

    _leftLab.text = name;
    _rightLab.text = money;
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

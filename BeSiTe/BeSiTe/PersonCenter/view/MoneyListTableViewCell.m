//
//  MoneyListTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyListTableViewCell.h"

@interface MoneyListTableViewCell ()

@property (nonatomic,strong) UILabel * leftLab;//左边lab
@property (nonatomic,strong) UIView * centerLine;//中间竖线
@property (nonatomic,strong) UILabel * rightLab;//右边lab
@property (nonatomic,strong) UIButton * retryBtn;//重试按钮

@end

@implementation MoneyListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat labWidth = MAXWIDTH /2 - 12 - 70;
        _leftLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, labWidth, 20)];
        [self.contentView addSubview:_leftLab];
        
        _centerLine = [[UIView alloc]initWithFrame:CGRectMake(MAXWIDTH /2 - 12, 0, 1, 28)];
        _centerLine.backgroundColor = UIColorFromRGBValue(0xe3e3e3);
        [self.contentView addSubview:_centerLine];
        
        _rightLab = [[UILabel alloc]initWithFrame:CGRectMake(MAXWIDTH /2 -2, 0, labWidth, 20)];
        [self.contentView addSubview:_rightLab];
        
        _retryBtn = [[UIButton alloc]initWithFrame:CGRectMake(MAXWIDTH / 2 -12 + 5, 0, MAXWIDTH / 2 -12 - 10, 28)];
        [_retryBtn setTitle:@"查询失败，点击重试" forState:UIControlStateNormal];
        [_retryBtn setTitleColor:UIColorFromINTValue(0, 146, 0) forState:UIControlStateNormal];
        [_retryBtn addTarget:self action:@selector(retryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _retryBtn.titleLabel.font = kFont(12);
        [self.contentView addSubview:_retryBtn];
        
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
            _centerLine.height = 37;
            }
            break;
        case CellTypeOther:{
            _leftLab.font = _rightLab.font = kFont(12);
            _leftLab.textColor =  UIColorFromINTValue(114, 113, 113);
            _rightLab.textColor = UIColorFromINTValue(0, 146, 0);
            _centerLine.height = 28;
        }
            break;
        default:{
            _leftLab.font = _rightLab.font = kFont(12);
            _leftLab.textColor =  UIColorFromINTValue(114, 113, 113);
            _rightLab.textColor = UIColorFromINTValue(0, 146, 0);
            _centerLine.height = 28;
        }
            break;
    }
}
-(void)setCell:(NSString *)name money:(NSString *)money whiteBack:(BOOL)isWhite{
    self.contentView.backgroundColor = isWhite ? kWhiteColor :UIColorFromINTValue(248, 246, 247);

    _leftLab.text = name;
    NSRange range = [money rangeOfString:@"失败"];
    if (range.length) {
        _rightLab.hidden = YES;
        _retryBtn.hidden = NO;
    }else{
        _rightLab.text = money;
        _rightLab.hidden = NO;
        _retryBtn.hidden = YES;
    }
}


-(void)retryBtnClick{
    if (self.retryBlock) {
        self.retryBlock(_leftLab.text);
    }
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

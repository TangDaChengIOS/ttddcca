//
//  PersonSavingTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/29.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonSavingTableViewCell.h"

@interface PersonSavingTableViewCell ()
@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * detailLab;
@property (nonatomic,strong) UILabel * rightLab;
@end

@implementation PersonSavingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 33, 33)];
        [self.contentView addSubview:_leftImageView];
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.maxX + 12, 12, 100, 15)];
        [self.contentView addSubview:_titleLab];
        
        _detailLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.maxX + 12, 32, 200, 15)];
        [self.contentView addSubview:_detailLab];
        
        _rightLab = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.width /2 + 30, 0, 100, 15)];
        [self.contentView addSubview:_rightLab];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 57, MAXWIDTH, 1)];
        line.backgroundColor = UIColorFromRGBValue(0xf3f3f3);
        [self.contentView addSubview:line];
        
        _titleLab.font  = kFont(15);
        _titleLab.textColor = kBlackColor;
        _detailLab.font = kFont(12);
        _detailLab.textColor = UIColorFromRGBValue(0x666666);
    }
    return self;
}
-(void)setCellType:(PersonSavingCellType)cellType
{
    _cellType = cellType;
    _detailLab.hidden = YES;
    _titleLab.centerY = _leftImageView.centerY;
    _rightLab.hidden = NO;
    NSMutableAttributedString * mAttStr = [[NSMutableAttributedString alloc]initWithString:@"额外送" attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)}];
    
    NSAttributedString * atStr = [[NSAttributedString alloc]initWithString:@"2%" attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:UIColorFromINTValue(244, 35, 38)}];
    [mAttStr appendAttributedString:atStr];
    _rightLab.attributedText = mAttStr;
    _rightLab.centerY = _leftImageView.centerY;
    
    switch (cellType) {
        case PersonSavingCellTypeBank:{
            _leftImageView.image = KIMAGE(@"profile_transaction_unlonPay_icon");
            _titleLab.text = @"秒存 工行网银";
            }
            break;
        case PersonSavingCellTypeZFB:{
            _leftImageView.image = KIMAGE(@"profile_transaction_alipay_icon");
            _titleLab.text = @"秒存 支付宝";

        }
            break;
        case PersonSavingCellTypeOnline:{
            _detailLab.hidden = NO;
            _leftImageView.image = KIMAGE(@"profile_transaction_online_icon");
            _titleLab.text = @"在线存款";
            _detailLab.text = @"单笔限额10-100000元";
            _titleLab.top = _leftImageView.top;
            _detailLab.top = 30;
            _rightLab.hidden = YES;

        }
            break;
        default:
            break;
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

//
//  OnlineSavingTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/27.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "OnlineSavingTableViewCell.h"

@interface OnlineSavingTableViewCell ()
@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * detailLab;
@property (nonatomic,strong) UIButton * rightButton;

@property (nonatomic,strong) UIView * translucentView;
@end

@implementation OnlineSavingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 33, 33)];
        [self.contentView addSubview:_leftImageView];
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.maxX + 12, 12, 100, 15)];
        [self.contentView addSubview:_titleLab];
        
        _detailLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.maxX + 12, 32, 200, 15)];
        [self.contentView addSubview:_detailLab];
        
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(MAXWIDTH - 60, 9, 40, 40)];
        [_rightButton setImage:KIMAGE_Ori(@"profile_onlinePay_btn_img") forState:UIControlStateNormal];
        [_rightButton setImage:KIMAGE_Ori(@"profile_onlinePay_btn_select_img") forState:UIControlStateSelected];
        _rightButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_rightButton];
        
        UIView * boomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 57, MAXWIDTH, 1)];
        boomLine.backgroundColor = UIColorFromINTValue(246, 246, 246);
        [self.contentView addSubview:boomLine];
        
        _titleLab.font  = kFont(15);
        _titleLab.textColor = kBlackColor;
        _detailLab.font = kFont(12);
        _detailLab.textColor = UIColorFromRGBValue(0x666666);
        _titleLab.top = _leftImageView.top;
        _detailLab.top = 30;
        
    }
    return self;
}
-(void)setCellWithModel:(OnlinePayModel *)payModel
{

    if (payModel.status ==1) {
        [_leftImageView setImageWithURL:[NSURL URLWithString:payModel.icon] placeholder:nil];;
        _titleLab.text = payModel.payName;
        _titleLab.top = _leftImageView.top;
        _detailLab.hidden = NO;
        _detailLab.attributedText = [payModel getMoneyCoverAttributedString];
        _rightButton.hidden = NO;
        _rightButton.selected = NO;

        if (_translucentView) {
            [_translucentView removeFromSuperview];
        }
    }
    else{
        [_leftImageView setImageWithURL:[NSURL URLWithString:payModel.icon] placeholder:nil];
        _titleLab.centerY = _leftImageView.centerY;
        _titleLab.text = @"维护中";
        _detailLab.hidden = YES;
        _rightButton.hidden = YES;
        [self translucentView];
    }
}

-(void)setCellSelected{
    self.rightButton.selected = YES;
}


-(UIView *)translucentView
{
    if (!_translucentView) {
        _translucentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, 57)];
        _translucentView.backgroundColor = UIColorFromINTRGBA(255, 255, 255, 0.8);
        [self.contentView addSubview:_translucentView];
    }
    return _translucentView;
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

//
//  MessageTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()
@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UIView * unredView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * timeLab;
@property (nonatomic,strong) UIImageView * rightImageView;

@property (nonatomic,strong) UIView * detailContentView;
@property (nonatomic,strong) UITextView * detailTextView;
@property (nonatomic,strong) UIButton * replyBtn;
@property (nonatomic,strong) UserMsgModel * model;
@end

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _unredView = [[UIView alloc]initWithFrame:CGRectMake(8, 16, 4, 4)];
        _unredView.backgroundColor = [UIColor redColor];
        _unredView.layer.cornerRadius = 2;
        [self.contentView addSubview:_unredView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.contentView.width -55, 16)];
        _titleLab.textColor = UIColorFromRGBValue(0x545454);
        _titleLab.font = kFont(14);
        [self.contentView addSubview:_titleLab];
        
        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, self.contentView.width -55 , 14)];
        _timeLab.textColor = UIColorFromRGBValue(0x929292);
        _timeLab.font = kFont(12);
        [self.contentView addSubview:_timeLab];
        
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH - 46, 14, 26, 26)];
        _rightImageView.contentMode = UIViewContentModeCenter;
        _rightImageView.image =KIMAGE(@"common_next_icon") ;
        
        [self.contentView addSubview:_rightImageView];
        
        _detailContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 53, MAXWIDTH, 1)];
        _detailContentView.backgroundColor = UIColorFromINTValue(246, 244, 245);
        [self.contentView addSubview:_detailContentView];
        
        _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(16, 16, MAXWIDTH - 32, 120)];
        _detailTextView.textColor = UIColorFromINTValue(101, 101, 101);
        _detailTextView.editable = NO;
        _detailTextView.font = kFont(12);
        _detailTextView.backgroundColor = [UIColor clearColor];
        [_detailContentView addSubview:_detailTextView];
        
        _replyBtn = [[UIButton alloc]initWithFrame:CGRectMake(MAXWIDTH - 85, _detailTextView.maxY + 15, 70, 30)];
        _replyBtn.backgroundColor = UIColorFromINTValue(26, 174, 106);
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _replyBtn.layer.cornerRadius = 3.0f;
        [_replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_detailContentView addSubview:_replyBtn];
        
        _detailContentView.clipsToBounds = YES;
    }
    return self;
}

-(void)setSystemCellWithModel:(SystemNoticesModel *)model isOpenState:(BOOL)isOpen
{
    self.titleLab.text = model.title;
    self.timeLab.text = model.time;
    self.unredView.hidden = [model.status isEqualToString:@"0"] ? NO : YES;
    self.detailTextView.text = model.content;
    if (!isOpen) {
        _detailContentView.height = 1;
        _rightImageView.image =KIMAGE(@"common_next_icon");
    }else{
        _replyBtn.hidden = YES;
        _detailContentView.height = _detailTextView.maxY + 15;
        _rightImageView.image =  KIMAGE(@"common_open_icon");
    }
}

-(void)setUserMsgCellWithModel:(UserMsgModel *)model isOpenState:(BOOL)isOpen{
    _model = model;
    self.titleLab.text = model.title;
    self.timeLab.text = model.time;
    self.unredView.hidden = [model.status isEqualToString:@"0"] ? NO : YES;
    self.detailTextView.text = model.content;
    if (!isOpen) {
        _detailContentView.height = 1;
        _rightImageView.image =KIMAGE(@"common_next_icon");
    }else{
        _replyBtn.hidden = NO;
        _detailContentView.height = _replyBtn.maxY + 15;
        _rightImageView.image =  KIMAGE(@"common_open_icon");
    }
}


-(void)replyBtnClick{
    if (self.replyBlock) {
        self.replyBlock(_model);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

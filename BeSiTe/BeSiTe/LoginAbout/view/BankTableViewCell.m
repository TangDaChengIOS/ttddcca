//
//  BankTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/6.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BankTableViewCell.h"

@interface BankTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLab;
@property (nonatomic,strong) BankModel * model;

@end

@implementation BankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellWithModel:(BankModel *)model{
    _model = model;
    [_bankImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:nil];
    _bankNameLab.text = model.bankName;
    _bankCardLab.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

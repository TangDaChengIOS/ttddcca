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
    [_bankImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:KIMAGE(@"common_bank_")];
    _bankNameLab.text = model.bankName;
    _bankCardLab.hidden = YES;
    self.bankNameLab.textColor = UIColorFromRGBValue(0x535353);
}

-(void)setMyBankCellWithModel:(MyBankModel *)model{
    [_bankImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:KIMAGE(@"common_bank_")];
    _bankNameLab.text = model.bankName;
    _bankCardLab.hidden = NO;
    if (model.cardNo.length > 4) {
        _bankCardLab.text = [NSString stringWithFormat:@"尾号%@",[model.cardNo substringFromIndex:model.cardNo.length - 4]];
    }else{
        _bankCardLab.text = [NSString stringWithFormat:@"尾号%@",model.cardNo];
    }
    self.bankNameLab.textColor = UIColorFromRGBValue(0x535353);
}
-(void)setIsCanClick:(BOOL)isCanClick{
    if (isCanClick) {
        self.bankNameLab.textColor = UIColorFromRGBValue(0x535353);
    }else{
        self.bankNameLab.textColor = UIColorFromRGBValue(0xe3e3e3);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MenuTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/19.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MenuTableViewCell.h"

@interface MenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *numBtn;

@end

@implementation MenuTableViewCell

-(void)setCellWith:(NSString *)title isSingleLine:(BOOL)isSingleLine cellShowTypeImage:(CellShowTypeImgae)type num:(NSInteger)num
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = isSingleLine? UIColorFromINTValue(40, 40, 42): UIColorFromINTValue(35, 35, 37);
    self.leftLab.textColor = isSingleLine ?kWhiteColor: UIColorFromINTValue(182, 182, 182);
    self.leftLab.text = title;
    
    _rightImageVIew.hidden = NO;
    _numBtn.hidden = YES;
    switch (type) {
        case CellShowTypeImgaeNone:{
            _rightImageVIew.hidden = YES;
            if (num > 0) {
                _numBtn.hidden  = NO;
                [_numBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
            }
        }
            break;
        case CellShowTypeImgaeHot:{
            _rightImageVIew.image = KIMAGE(@"home_left_hot_icon");
        }
            break;
        case CellShowTypeImgaeNew:{
            _rightImageVIew.image = KIMAGE(@"home_left_new_icon");
        }
            break;
        default:
            break;
    }
}
-(void)setCellWithModel:(GamesCompanyModel *)model :(BOOL)isSingleLine{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = isSingleLine? UIColorFromINTValue(40, 40, 42): UIColorFromINTValue(35, 35, 37);
    self.leftLab.textColor = isSingleLine ?kWhiteColor: UIColorFromINTValue(182, 182, 182);
    self.leftLab.text = model.companyName;
    
    _rightImageVIew.hidden = NO;
    _numBtn.hidden = YES;
    
    if (model.isHot) {
        _rightImageVIew.image = KIMAGE(@"home_activity_hot_icon");
    }
    else{
        if (model.isNew) {
            _rightImageVIew.image = KIMAGE(@"home_game_platform_new_icon");
        }
        else{
            _rightImageVIew.image = nil;
        }
    }
    
 
//    if (num > 0) {
//            _numBtn.hidden  = NO;
//            [_numBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
//    }
}



- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

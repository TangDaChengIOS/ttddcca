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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timeLab = [[UILabel alloc]init];
        _timeLab.backgroundColor = UIColorFromINTValue(218, 218, 218);
        _timeLab.textColor = kWhiteColor;
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = kFont(10);
        [self.contentView addSubview:_timeLab];
        kWeakSelf
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weak_self.contentView);
            make.height.mas_equalTo(@18);

        }];

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.timeLab.layer.cornerRadius = 2.0f;
    self.timeLab.layer.masksToBounds = YES;

}
-(void)setTimeStr:(NSString *)timeStr{
    _timeLab.text = [NSString stringWithFormat:@" %@ ",timeStr];

}

- (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
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

//
//  UIButton_withBadge.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "UIButton_withBadge.h"

@interface UIButton_withBadge ()
@property (nonatomic,strong) UILabel * badgeLab;
@property (nonatomic,assign) CGFloat defaultOriginX;
@property (nonatomic,copy) NSString * badgeStr;
@end

@implementation UIButton_withBadge

-(UILabel *)badgeLab{
    if (!_badgeLab) {
        _badgeLab = [[UILabel alloc]init];
        _badgeLab.backgroundColor = [UIColor redColor];
        _badgeLab.textColor = kWhiteColor;
        _badgeLab.font = kFont(8);
        _badgeLab.textAlignment = NSTextAlignmentCenter;
        _badgeLab.adjustsFontSizeToFitWidth = YES;

        [self addSubview:_badgeLab];
    }
    return _badgeLab;
}


-(void)setBadgeValue:(NSUInteger)badgeValue
{
    _badgeValue = badgeValue;
    _badgeStr = [NSString stringWithFormat:@"%ld",badgeValue];
    if (badgeValue <= 0) {
        self.badgeLab.hidden = YES;
    }
    else{
        self.badgeLab.hidden = NO;
        [self adjustLabFrame];
    }
}

-(void)adjustLabFrame
{
    CGFloat font = 8;
    if (_badgeValue > 99) {
        font = 6;
        _badgeStr = @"99+";
    }
    CGSize size = [_badgeStr sizeWithAttributes:@{NSFontAttributeName:kFont(font)}];
    CGFloat minWidth = 8;
    
    minWidth = (minWidth < size.width) ? size.width : minWidth ;
    self.badgeLab.layer.masksToBounds = YES;
    
    minWidth += 6;
    self.badgeLab.frame = CGRectMake(self.badgeLab.superview.width - minWidth -3  , 3, minWidth, minWidth);
    self.badgeLab.layer.cornerRadius = minWidth / 2;
    self.badgeLab.text = _badgeStr;
}

@end

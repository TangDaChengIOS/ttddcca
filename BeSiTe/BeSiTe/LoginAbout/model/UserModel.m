//
//  UserModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/3.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(NSString *)getVipImageStr{
    return [NSString stringWithFormat:@"common_VIP-%ld",self.vipLevel];
}


+(NSAttributedString *)getTotalMoneyAttributeString
{
    CGFloat money = [BSTSingle defaultSingle].user.userAmount;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@",###.00"];
    NSLog(@"%@",[NSNumber numberWithFloat:money]);
    NSString *convertNumber = [formatter stringFromNumber:[NSNumber numberWithDouble:money]];
    
    NSMutableAttributedString * mAtStr = [[NSMutableAttributedString alloc]initWithString:@"主账户余额 " attributes:@{NSFontAttributeName:kFont(15),NSForegroundColorAttributeName:UIColorFromINTValue(124, 124, 124)}];
    NSAttributedString * atStr = [[NSAttributedString alloc]initWithString:convertNumber attributes:@{NSFontAttributeName:kFont(15),NSForegroundColorAttributeName:UIColorFromINTValue(24, 119, 1)}];
    [mAtStr appendAttributedString:atStr];
    return mAtStr;
}
@end

//
//  OnlinePayModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/27.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "OnlinePayModel.h"

@implementation OnlinePayModel

-(NSAttributedString *)getMoneyCoverAttributedString{
    
    NSString *sourceString = [NSString stringWithFormat:@"最低%@元 最高%@元",self.minAmount,self.maxAmount];
    NSRange  range1 = [sourceString rangeOfString:self.minAmount options:NSLiteralSearch];
    NSRange  range2 = [sourceString rangeOfString:self.maxAmount options:NSLiteralSearch];
    
    NSMutableAttributedString * mAStr = [[NSMutableAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xa1a1a1),NSFontAttributeName:kFont(12)}];
    
    [mAStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x54ad41)} range:range1];
    [mAStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x54ad41)} range:range2];

 
    return mAStr;

}



@end

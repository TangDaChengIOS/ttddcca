//
//  MoneyRecordModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyRecordModel.h"

@implementation MoneyRecordModel


-(UIColor *)quKuanStateLabTextColor
{
 
    switch ([_status integerValue]) {
        case 0:
        case 1:
        case 2:
        case 5:
        case 6:
            return UIColorFromINTValue(0, 149, 213);//浅蓝色
            break;
        case 3:
            return UIColorFromINTValue(192, 96, 98);//浅红色
            break;
        case 4:
            return UIColorFromINTValue(68, 152, 47);//浅绿色
            break;
        default:
            return UIColorFromINTValue(110, 110, 110);//浅黑色
            break;
    }
}

-(UIColor *)cunKuanStateLabTextColor
{
    
    switch ([_status integerValue]) {
        case 0:
            return UIColorFromINTValue(192, 96, 98);//浅红色
            break;
        case 1:
            return UIColorFromINTValue(68, 152, 47);//浅绿色
            break;
        default:
            return UIColorFromINTValue(110, 110, 110);//浅黑色
            break;
    }
}

-(UIColor *)otherStateLabTextColor
{
    
    switch ([_status integerValue]) {
        case 0:
            return UIColorFromINTValue(0, 149, 213);//浅蓝色
            break;
        case 1:
            return UIColorFromINTValue(68, 152, 47);//浅绿色
            break;
        case 2:
            return UIColorFromINTValue(192, 96, 98);//浅红色
            break;
        default:
            return UIColorFromINTValue(110, 110, 110);//浅黑色
            break;
    }
}

@end

//
//  GamesModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GamesModel.h"

@implementation GamesModel


-(UIImage *)getTypeImage{
    if (_isHot) {
        return  KIMAGE(@"home_left_hot_icon");
    }
    else{
        if (_isNew) {
            return  KIMAGE(@"home_left_new_icon");
        }
        else{
            return  nil;
        }
    }
}
-(NSString *)companyCode{
    if (!_companyCode) {
        return @"";
    }
    return _companyCode;
}

-(void)refreshCaches
{
    id objec = [[NSUserDefaults standardUserDefaults]objectForKey:self.companyCode];
    //结构 [ {"key":[{},{}... ] } ]
    if (objec)
    {
        NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:objec[0]];
        NSMutableArray * mArr = [NSMutableArray array];
        NSArray * temp = mDict[@"list"];
        for (NSDictionary * dict in temp) {
            NSString * gameCode = dict[@"gameCode"];
            if ([gameCode isEqualToString:self.gameCode]) {
                NSMutableDictionary * mmDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mmDict setValue:(self.isFav ? @"1":@"0") forKey:@"isFav"];
                [mArr addObject:mmDict];
            }else{
                [mArr addObject:dict];
            }
        }
        [mDict setObject:mArr forKey:@"list"];
        [[NSUserDefaults standardUserDefaults]setObject:@[mDict] forKey:self.companyCode];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end

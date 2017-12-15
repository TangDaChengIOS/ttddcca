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

@end

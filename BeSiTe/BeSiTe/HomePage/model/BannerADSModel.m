//
//  BannerADSModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BannerADSModel.h"

@implementation BannerADSModel

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"game"]) {
        GamesModel * model = [GamesModel new];
        [model mj_setKeyValues:value];
        [super setValue:model forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
    
}
@end

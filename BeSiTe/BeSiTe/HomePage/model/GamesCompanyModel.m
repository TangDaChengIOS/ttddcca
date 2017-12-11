//
//  GamesCompanyModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GamesCompanyModel.h"

@implementation GamesCompanyModel

+(NSMutableArray *)jsonToArray:(id)json
{
    if ([[json class]isSubclassOfClass:[NSArray class]]) {
        NSMutableArray * mArr = [NSMutableArray array];
        NSMutableArray * notShowInHomePageArr = [NSMutableArray array];

        for (NSDictionary * dict in json) {
            GamesCompanyModel * model = [[self alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            if (model.mainShow) {
                [mArr addObject:model];
            }else{
                [notShowInHomePageArr addObject:model];
            }
        }
        [notShowInHomePageArr insertObjects:mArr atIndex:0];
        [BSTSingle defaultSingle].companysArray = notShowInHomePageArr;
        
        return mArr;
    }
    else{
        return  [NSMutableArray array];
    }
}


@end

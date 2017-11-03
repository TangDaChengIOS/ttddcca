//
//  ATBaseModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/17.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@implementation ATBaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"data_id"];
    }
}

//+(NSMutableArray *)jsonToArray:(id)json
//{
//    return [NSMutableArray array];
//}

+(NSMutableArray *)jsonToArray:(id)json
{
    if ([[json class]isSubclassOfClass:[NSArray class]]) {
        NSMutableArray * mArr = [NSMutableArray array];
        for (NSDictionary * dict in json) {
            ATBaseModel * model = [[self alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [mArr addObject:model];
        }
        return mArr;
    }
    else{
        return  [NSMutableArray array];
    }
}

@end

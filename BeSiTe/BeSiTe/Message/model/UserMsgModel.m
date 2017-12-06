//
//  UserMsgModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "UserMsgModel.h"

@implementation UserMsgModel


@end


@implementation UserMsgReplyModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"reply"]) {
        NSMutableArray * mArr = [NSMutableArray array];
        for (NSDictionary * dict in value) {
            ReplyModel * model = [ReplyModel new];
            [model mj_setKeyValues:dict];
            [mArr addObject:model];
        }
        [super setValue:mArr forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation ReplyModel



@end

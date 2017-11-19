//
//  ATCombineStrings.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/10.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATCombineStrings.h"

@implementation ATCombineStrings

+(NSAttributedString *)combineStrings:(NSArray<NSString *>*)strings withAttributes:(NSArray <NSDictionary *>*)attributes
{
    if (strings.count <= 0) {
        return [NSAttributedString new];
    }
    NSMutableAttributedString * mAttStr = [[NSMutableAttributedString alloc]init];
    for (int i=0; i<strings.count; i++) {
        NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:strings[i] attributes:attributes[i]];
        [mAttStr appendAttributedString:attStr];
    }
    return mAttStr;
}

@end

//
//  CheckIfNeedUpdateModel.m
//  BeSiTe
//
//  Created by 汤达成 on 18/1/8.
//  Copyright © 2018年 Tang. All rights reserved.
//

#import "CheckIfNeedUpdateModel.h"

@implementation CheckIfNeedUpdateModel


-(BOOL)isNeedUpdate{
    if (!_verNo) {
        return NO;
    }
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([version compare:_verNo options:NSLiteralSearch] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

@end

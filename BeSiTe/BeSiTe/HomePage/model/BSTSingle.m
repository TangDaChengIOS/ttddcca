//
//  BSTSingle.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BSTSingle.h"

@implementation BSTSingle

+(instancetype)defaultSingle{
    static dispatch_once_t onceToken;
    static BSTSingle * single = nil;
    dispatch_once(&onceToken, ^{
        single = [[self alloc]init];
    });
    return single;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

//
//  MyBankModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/28.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MyBankModel.h"

@implementation MyBankModel

-(NSString *)icon
{
    if (![BSTSingle defaultSingle].bankCodeIcon) {
        return nil;
    }else{
        return [[BSTSingle defaultSingle].bankCodeIcon objectForKey:self.bankCode];
    }
}

@end

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

-(NSMutableDictionary *)moneyRecordSearchPara
{
    if (!_moneyRecordSearchPara) {
        _moneyRecordSearchPara = [NSMutableDictionary dictionary];
    }
    return _moneyRecordSearchPara;
}

-(void)updateGameCompany:(NSString *)gamePlatformCode balance:(NSString *)balance{
    if (gamePlatformCode.length == 0 || self.gameCompanysBalanceArr.count == 0) {
        return;
    }
    for (BalanceModel * model in self.gameCompanysBalanceArr)
    {
        if ([model.gamePlatformCode isEqualToString:gamePlatformCode]) {
            model.balance = balance;
        }
    }
}
-(NSMutableArray<BalanceModel *> *)gameCompanysBalanceArr
{
    if (!_gameCompanysBalanceArr) {
        _gameCompanysBalanceArr = [NSMutableArray array];
    }
    return _gameCompanysBalanceArr;
}
@end

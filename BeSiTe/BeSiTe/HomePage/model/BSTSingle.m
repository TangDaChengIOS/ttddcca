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

//@property (nonatomic,assign) NSInteger adsRollTime;//首页轮播图滚动时间间隔

-(void)setAdsRollTime:(NSInteger)adsRollTime
{
    if (_adsRollTime != adsRollTime) {
        _adsRollTime = adsRollTime;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADSRollTimeChangedNotification" object:nil];
    }
}

-(void)setActivityUnreadNum:(NSInteger)activityUnreadNum
{
    if (activityUnreadNum <0) {
        _activityUnreadNum = 0;
    }
    else{
        _activityUnreadNum = activityUnreadNum;
    }
}

-(void)setNoticeNums:(NSInteger)noticeNums
{
    if (noticeNums < 0) {
        _noticeNums = 0;
    }else{
        _noticeNums = noticeNums;
    }
    _totalNums = _noticeNums + _msgNums;
}

-(void)setMsgNums:(NSInteger)msgNums{
    if (msgNums < 0) {
        _msgNums = 0;
    }else{
        _msgNums = msgNums;
    }
    _totalNums = _noticeNums + _msgNums;
}




@end

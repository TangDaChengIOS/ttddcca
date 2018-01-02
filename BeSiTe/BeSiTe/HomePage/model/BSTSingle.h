//
//  BSTSingle.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamesCompanyModel.h"
#import "UserModel.h"
#import "BalanceModel.h"

/**BST单例*/
@interface BSTSingle : NSObject

@property (nonatomic,strong) NSArray <GamesCompanyModel *>* companysArray;

/**用户登录信息*/
@property (nonatomic,strong) UserModel * user;

/**存放查询记录的起止日期*/
@property (nonatomic,strong)NSMutableDictionary * moneyRecordSearchPara;

/**存放银行code对应的图标*/
@property (nonatomic,strong)NSMutableDictionary * bankCodeIcon;

/**存放滚屏公告*/
@property (nonatomic,strong) NSMutableAttributedString * notices;

/**存放各个平台余额*/
@property (nonatomic,strong) NSMutableArray <BalanceModel *>* gameCompanysBalanceArr;

@property (nonatomic,copy) NSString * registerAgreementUrl;//注册协议
@property (nonatomic,copy) NSString * aboutUSUrl;//关于我们
@property (nonatomic,copy) NSString * vipExplainUrl;//VIP介绍
@property (nonatomic,copy) NSString * remitUrl;//汇款单号查询链接

@property (nonatomic,assign) NSInteger adsRollTime;//首页轮播图滚动时间间隔
@property (nonatomic,assign) NSInteger activityUnreadNum;//活动未读数量

@property (nonatomic,assign) NSInteger noticeNums;//系统公告未读数
@property (nonatomic,assign) NSInteger msgNums;//个人消息未读数
@property (nonatomic,assign) NSInteger totalNums;//系统公告未读数+个人消息未读数

+(instancetype)defaultSingle;

-(void)updateGameCompany:(NSString *)gamePlatformCode balance:(NSString *)balance;

@end

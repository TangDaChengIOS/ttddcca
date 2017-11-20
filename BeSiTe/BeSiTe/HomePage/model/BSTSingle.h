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

/**BST单例*/
@interface BSTSingle : NSObject

@property (nonatomic,strong) NSArray <GamesCompanyModel *>* companysArray;

/**用户登录信息*/
@property (nonatomic,strong) UserModel * user;

/**存放查询记录的起止日期*/
@property (nonatomic,strong)NSMutableDictionary * moneyRecordSearchPara;

+(instancetype)defaultSingle;

@end

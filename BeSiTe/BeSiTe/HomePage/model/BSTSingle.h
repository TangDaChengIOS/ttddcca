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

@interface BSTSingle : NSObject

@property (nonatomic,strong) NSArray <GamesCompanyModel *>* companysArray;

@property (nonatomic,strong) UserModel * user;
+(instancetype)defaultSingle;

@end

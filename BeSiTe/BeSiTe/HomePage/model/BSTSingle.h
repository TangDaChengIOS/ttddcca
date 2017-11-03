//
//  BSTSingle.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamesCompanyModel.h"

@interface BSTSingle : NSObject

@property (nonatomic,strong) NSArray <GamesCompanyModel *>* companysArray;

+(instancetype)defaultSingle;

@end

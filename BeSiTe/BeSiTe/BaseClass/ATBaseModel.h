//
//  ATBaseModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/17.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATBaseModel : NSObject

@property (nonatomic,assign) NSInteger data_id;
+(NSMutableArray *)jsonToArray:(id)json;

@end

//
//  CheckIfNeedUpdateModel.h
//  BeSiTe
//
//  Created by 汤达成 on 18/1/8.
//  Copyright © 2018年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface CheckIfNeedUpdateModel : ATBaseModel

@property (nonatomic,copy) NSString * verNo;
@property (nonatomic,copy) NSString * downUrl;
@property (nonatomic,copy) NSString * updateContent;
@property (nonatomic,assign) NSInteger type;

-(BOOL)isNeedUpdate;

@end

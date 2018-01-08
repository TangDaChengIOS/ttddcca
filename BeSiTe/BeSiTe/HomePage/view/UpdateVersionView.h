//
//  UpdateVersionView.h
//  BeSiTe
//
//  Created by 汤达成 on 18/1/8.
//  Copyright © 2018年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"
#import "CheckIfNeedUpdateModel.h"

@interface UpdateVersionView : ATTranslucentView
@property (nonatomic,strong) CheckIfNeedUpdateModel * model;

+(void)showWithModel:(CheckIfNeedUpdateModel *)model;

@end

//
//  EmailTypeViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

@interface EmailTypeViewController : ATBaseViewController
@property (nonatomic,assign) BOOL  isClickItemGotoNextPage;
@property (nonatomic,copy) void (^finishBlock)(NSString * type);
@end

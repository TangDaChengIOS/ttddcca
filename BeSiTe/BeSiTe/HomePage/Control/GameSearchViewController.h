//
//  GameSearchViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

@interface GameSearchViewController : ATBaseViewController
@property (nonatomic,copy) void (^searchBlock)(NSString * searchKey);
@end

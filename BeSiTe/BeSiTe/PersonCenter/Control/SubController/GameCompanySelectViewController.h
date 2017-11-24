//
//  GameCompanySelectViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"
#import "GamesCompanyModel.h"

@interface GameCompanySelectViewController : ATBaseViewController

@property (nonatomic,copy) void (^finshSelectCompanyBlock)(GamesCompanyModel * model);

@end

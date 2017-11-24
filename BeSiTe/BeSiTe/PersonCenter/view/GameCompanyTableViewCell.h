//
//  GameCompanyTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamesCompanyModel.h"

#define kGameCompanyTableViewCellReuseID @"kGameCompanyTableViewCellReuseID"
@interface GameCompanyTableViewCell : UITableViewCell

-(void)setCellWithCompanyModel:(GamesCompanyModel *)model;

@end

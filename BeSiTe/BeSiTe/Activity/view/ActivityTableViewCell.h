//
//  ActivityTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

#define kActivityTableViewCellReuseID @"kActivityTableViewCellReuseID"
@interface ActivityTableViewCell : UITableViewCell

-(void)setCellWithModel:(ActivityModel *)model isOpenState:(BOOL)isOpen;

@end

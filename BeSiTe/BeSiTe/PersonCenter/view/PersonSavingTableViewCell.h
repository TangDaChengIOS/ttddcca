//
//  PersonSavingTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/29.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PersonSavingCellType) {
    PersonSavingCellTypeBank = 0,
    PersonSavingCellTypeZFB,
    PersonSavingCellTypeOnline
};

#define kPersonSavingTableViewCellReuseID @"kPersonSavingTableViewCellReuseID"
@interface PersonSavingTableViewCell : UITableViewCell
@property (nonatomic,assign) PersonSavingCellType cellType;
@end

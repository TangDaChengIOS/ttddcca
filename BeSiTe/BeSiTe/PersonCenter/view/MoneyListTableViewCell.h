//
//  MoneyListTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,CellType) {
    CellTypeFirstLine = 0,
    CellTypeOther
};
#define kMoneyListTableViewCellReuseID @"kMoneyListTableViewCellReuseID"

@interface MoneyListTableViewCell : UITableViewCell

@property (nonatomic,assign) CellType cellTye;
@property (nonatomic,copy) void (^retryBlock)(NSString *gameCompanyCode);
-(void)setCell:(NSString *)name money:(NSString *)money whiteBack:(BOOL)isWhite;

@end

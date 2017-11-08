//
//  MenuTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/19.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMenuTableViewCellReuseID @"kMenuTableViewCellReuseID"

typedef NS_ENUM(NSUInteger,CellShowTypeImgae) {
    CellShowTypeImgaeNone = 0 ,
    CellShowTypeImgaeHot,
    CellShowTypeImgaeNew
};
/**侧栏菜单的cell*/
@interface MenuTableViewCell : UITableViewCell
/**APP功能cell*/
-(void)setCellWith:(NSString *)title isSingleLine:(BOOL)isSingleLine cellShowTypeImage:(CellShowTypeImgae)type num:(NSInteger)num;
/**设置平台cell*/
-(void)setCellWithModel:(GamesCompanyModel *)model :(BOOL)isSingleLine;

@end
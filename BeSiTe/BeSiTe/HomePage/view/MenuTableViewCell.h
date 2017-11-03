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
@interface MenuTableViewCell : UITableViewCell

-(void)setCellWith:(NSString *)title isSingleLine:(BOOL)isSingleLine cellShowTypeImage:(CellShowTypeImgae)type num:(NSInteger)num;


@end

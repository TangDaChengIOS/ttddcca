//
//  MessageTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMessageTableViewCellReuseID @"kMessageTableViewCellReuseID"
@interface MessageTableViewCell : UITableViewCell

-(void)setIsOpenState:(BOOL)isOpen :(BOOL)isSystemMsg;
@end

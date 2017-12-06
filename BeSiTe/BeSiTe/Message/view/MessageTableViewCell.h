//
//  MessageTableViewCell.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SystemNoticesModel.h"
#import "UserMsgModel.h"

#define kMessageTableViewCellReuseID @"kMessageTableViewCellReuseID"
@interface MessageTableViewCell : UITableViewCell

@property (nonatomic,copy) void (^replyBlock)(UserMsgModel * model);

-(void)setSystemCellWithModel:(SystemNoticesModel *)model isOpenState:(BOOL)isOpen;
-(void)setUserMsgCellWithModel:(UserMsgModel *)model isOpenState:(BOOL)isOpen;

@end

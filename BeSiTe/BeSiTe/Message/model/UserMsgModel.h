//
//  UserMsgModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@class UserMsgReplyModel;
@class ReplyModel;
@interface UserMsgModel : ATBaseModel

@property (nonatomic,copy) NSString * msgId;//	string	消息ID
@property (nonatomic,copy) NSString * title;//	string	标题
@property (nonatomic,copy) NSString * time;//	string	时间
@property (nonatomic,copy) NSString * content;//	string	内容
@property (nonatomic,copy) NSString * typeName;//	string	消息分类名称
@property (nonatomic,copy) NSString * status;//	string	状态0:未读1:已读
@property (nonatomic,assign) NSInteger is_new;//string	状态0:没有 1:有新的回复

@end

@interface UserMsgReplyModel : UserMsgModel
@property (nonatomic,copy) NSString * userId;//	int	回复人 0:系统  其他表示用户
@property (nonatomic,copy) NSArray <ReplyModel *>* reply;

@end

@interface ReplyModel : ATBaseModel

@property (nonatomic,copy) NSString * replyId;//
@property (nonatomic,copy) NSString * time;//	string	时间
@property (nonatomic,copy) NSString * content;//	string	回复内容
@property (nonatomic,copy) NSString * userId;//	int	回复人 0:系统  其他表示用户

@end

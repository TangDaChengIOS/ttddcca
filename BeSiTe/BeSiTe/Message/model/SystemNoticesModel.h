//
//  SystemNoticesModel.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseModel.h"

@interface SystemNoticesModel : ATBaseModel

@property (nonatomic,copy) NSString * noticeId;//	string	公告ID
@property (nonatomic,copy) NSString * title;//	string	标题
@property (nonatomic,copy) NSString * time;//	string	时间
@property (nonatomic,copy) NSString * content;//	string	内容
@property (nonatomic,copy) NSString * status;//	string	状态0:未读1:已读


@end

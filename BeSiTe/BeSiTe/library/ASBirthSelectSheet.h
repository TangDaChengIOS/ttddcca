//
//  ASBirthSelectSheet.h
//  ASBirthSheet
//
//  Created by Ashen on 15/12/8.
//  Copyright © 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASBirthSelectSheet : UIActionSheet
@property (nonatomic, copy) void(^GetSelectDate)(NSString *dateStr);
@property (nonatomic, strong) NSString * selectDate;

//获取当前日期
+(NSString *)getCurrentDate;

//获取当前日期前一天
+(NSString *)getDayBeforeCurrentDate;
@end

//
//  UserModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/3.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(NSString *)getVipImageStr{
    NSInteger trueLevel = self.vipLevel >= 1 ? self.vipLevel - 1 : 0;
    return [NSString stringWithFormat:@"common_VIP-%ld",trueLevel];
}


+(NSAttributedString *)getTotalMoneyAttributeString
{
    CGFloat money = 0.00;
    NSString *convertNumber = @"0.00";
    if ([BSTSingle defaultSingle].user) {
         money = [BSTSingle defaultSingle].user.userAmount;
        if (money > 0) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@",###.00"];
            convertNumber = [formatter stringFromNumber:[NSNumber numberWithDouble:money]];
        }
    }
    
    NSMutableAttributedString * mAtStr = [[NSMutableAttributedString alloc]initWithString:@"主账户余额 " attributes:@{NSFontAttributeName:kFont(15),NSForegroundColorAttributeName:UIColorFromINTValue(124, 124, 124)}];
    NSAttributedString * atStr = [[NSAttributedString alloc]initWithString:convertNumber attributes:@{NSFontAttributeName:kFont(15),NSForegroundColorAttributeName:UIColorFromINTValue(24, 119, 1)}];
    [mAtStr appendAttributedString:atStr];
    return mAtStr;
}

+(void)saveLoginData:(NSDictionary *)data andAccountName:(NSString *)accountName
{
    NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:data];
    [mDict setValue:accountName forKey:@"accountName"];
    [mDict setObject:[NSDate date] forKey:@"loginTime"];
    
    [[NSUserDefaults standardUserDefaults] setObject:mDict forKey:kSavingUserInfoKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)isSuccessReadSavedLoginData
{
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:kSavingUserInfoKey];
    if (!dict) {
        return NO;
    }
    NSDate * lastDate = [dict objectForKey:@"loginTime"];
    NSDate * maxDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:lastDate];
    
    if ([maxDate compare:[NSDate date]] == NSOrderedAscending)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSavingUserInfoKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [BSTSingle defaultSingle].user = nil;
        return NO;
    }
    else{
        UserModel * model = [[UserModel alloc]init];
        [model mj_setKeyValues:dict];
        model.userAmount = 0.00;
        [BSTSingle defaultSingle].user = model;
        return YES;
    }
}

@end

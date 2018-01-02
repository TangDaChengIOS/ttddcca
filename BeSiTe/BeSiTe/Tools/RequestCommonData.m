//
//  RequestCommonData.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RequestCommonData.h"

@implementation RequestCommonData


+(void)getUnReadMsgNums
{
    [RequestManager getManagerDataWithPath:@"user/msgNums" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            return ;
        }
        [[BSTSingle defaultSingle] mj_setKeyValues:JSON];
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetUnReadMsgNumsSuccessNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
}


+(void)getNoticesData{
    kWeakSelf
    [RequestManager getWithPath:@"notices" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [weak_self handleNotices:JSON];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 处理滚屏公告
+(void)handleNotices:(id)json
{
    if ([[json class]isSubclassOfClass:[NSArray class]])
    {
        NSMutableAttributedString * mAttStr = [[NSMutableAttributedString alloc]init];
        for (int i = 0; i < [(NSArray *)json count]; i++) {
            NSDictionary * dict = json[i];
            NSString * content =[NSString stringWithFormat:@"%@   ", dict[@"content"]];
            [mAttStr appendAttributedString: [self  getAttributeString:content]];
        }
        [BSTSingle defaultSingle].notices = mAttStr;
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetNoticesDataSuccessNotification object:nil];
    }else{
        
    }
}
#pragma mark -- 将滚动文字转为带属性的文字
+(NSAttributedString *)getAttributeString:(NSString *)sourceString
{
    NSRange  range1 = [sourceString rangeOfString:@"尊贵的" options:NSLiteralSearch];
    NSRange  range2 = [sourceString rangeOfString:@"会员" options:NSLiteralSearch];
    
    if (range1.length == 0 || range2.length == 0)
    {
        return [[NSAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kFont(13)}];
    }
    else
    {
        if (range2.location > (range1.location + range1.length))
        {
            NSRange range = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
            
            NSMutableAttributedString * mAStr = [[NSMutableAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kFont(13)}];
            
            NSAttributedString * aStr = [[NSAttributedString alloc]initWithString:[sourceString substringWithRange:range] attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(0, 246, 17),NSFontAttributeName:kFont(13)}];
            
            [mAStr replaceCharactersInRange:range withAttributedString:aStr];
            return mAStr;
        }
        else
        {
            return [[NSAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kFont(13)}];
        }
    }
}

@end

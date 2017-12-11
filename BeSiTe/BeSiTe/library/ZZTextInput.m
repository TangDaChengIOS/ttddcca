//
//  ZZTextInput.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ZZTextInput.h"

@implementation ZZTextInput
/**只能为中文*/
+(BOOL)onlyInputChineseCharacters:(NSString*)string{
    NSString *zhString = @"[\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zhString];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}
/**只能为数字*/
+(BOOL)onlyInputTheNumber:(NSString*)string{
    if (string.length == 0) return NO;
    
    NSString *numString =@"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numString];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

/**只能输入最多两位小数的金额*/
+(BOOL)onlyInputMoney:(NSString*)string{
    NSString *numString =@"^[0-9]+(.[0-9]{2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numString];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

/**只能为小写*/
+(BOOL)onlyInputLowercaseLetter:(NSString*)string{
    NSString *regex =@"[a-z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

/**只能为大写*/
+(BOOL)onlyInputACapital:(NSString*)string{
    NSString *regex =@"[A-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

/**允许大小写*/
+(BOOL)InputCapitalAndLowercaseLetter:(NSString*)string{
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

/**允许含大小写或数字(不限字数)*/
+(BOOL)inputLettersOrNumbers:(NSString*)string{
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

/**以数字、大小写字母、下划线组成的6-15位*/
+(BOOL)inputNumberOrLetters:(NSString*)name {
//    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSString *userNameRegex = @"^[a-zA-Z0-9_]{6,15}+$";

    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL inputString = [userNamePredicate evaluateWithObject:name];
    return inputString;
}
/**验证是否手机号*/
+ (BOOL)isValidateMobile:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isEmailAddress:(NSString *)emailAddr
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];

    return [emailTest evaluateWithObject:emailAddr];
}

+(NSString *)getBadgeValue:(NSInteger)value{
    if (value <= 0) {
        return nil;
    }
    else{
        return [NSString stringWithFormat:@"%ld",value];
    }
}


void TTAlert(NSString* message) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
@end

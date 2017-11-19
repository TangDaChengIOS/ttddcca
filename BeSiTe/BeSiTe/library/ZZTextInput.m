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
    NSString *numString =@"[0-9]*";
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
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isEmailAddress:(NSString *)emailAddr
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];

    return [emailTest evaluateWithObject:emailAddr];
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

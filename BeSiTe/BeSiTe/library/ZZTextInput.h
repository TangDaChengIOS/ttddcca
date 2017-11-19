//
//  ZZTextInput.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**利用正则表达式，检测输入内容*/
@interface ZZTextInput : NSObject

/**只能为中文*/
+(BOOL)onlyInputChineseCharacters:(NSString*)string;
/**只能为数字*/
+(BOOL)onlyInputTheNumber:(NSString*)string;
/**只能为小写*/
+(BOOL)onlyInputLowercaseLetter:(NSString*)string;

/**只能为大写*/
+(BOOL)onlyInputACapital:(NSString*)string;

/**允许大小写*/
+(BOOL)InputCapitalAndLowercaseLetter:(NSString*)string;

/**允许含大小写或数字(不限字数)*/
+(BOOL)inputLettersOrNumbers:(NSString*)string;

/**以数字、大小写字母、下划线组成的6-15位*/
+(BOOL)inputNumberOrLetters:(NSString*)name;

/**验证是否手机号*/
+ (BOOL)isValidateMobile:(NSString *)mobile;

/**验证是正确的邮箱号*/
+ (BOOL)isEmailAddress:(NSString *)emailAddr;


void TTAlert(NSString* message);
@end

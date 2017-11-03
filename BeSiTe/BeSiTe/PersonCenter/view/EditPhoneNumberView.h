//
//  EditPhoneNumberView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATTranslucentView.h"

typedef NS_ENUM(NSInteger,EditPhoneNumberViewType) {
    EditPhoneNumberViewTypeEdit = 0,//修改手机号
    EditPhoneNumberViewTypeVerify//验证手机号
};

/**修改、验证手机号*/
@interface EditPhoneNumberView : ATTranslucentView
@property (nonatomic,assign) EditPhoneNumberViewType editType ;
+(void)show;

@end

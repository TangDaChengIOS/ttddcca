//
//  RegisterSuccessView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShowType) {
    ShowTypeWaitThreeSec = 0,//显示等待3S
    ShowTypeWaitThreeSec_TLD,//显示等待3S，描述两行
    ShowTypeShowTwoSel,//下方两个按钮
    ShowTypeShowOneSel//下方一个按钮
};

@interface RegisterSuccessView : UIView

@property (nonatomic,assign) ShowType showType;
+(void)show;

@end

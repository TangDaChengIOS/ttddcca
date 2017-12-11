//
//  MBProgressHUD+ATADD.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/6.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MBProgressHUD+ATADD.h"

@implementation MBProgressHUD (ATADD)

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = kFont(15);
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;    // YES代表需要蒙版效果
    return hud;
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view animated:YES];
}


@end

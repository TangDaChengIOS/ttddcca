//
//  MBProgressHUD+ATADD.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/6.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (ATADD)

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view ;
+ (void)hideHUDForView:(UIView *)view;

@end

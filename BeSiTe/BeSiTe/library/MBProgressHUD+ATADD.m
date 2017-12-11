//
//  MBProgressHUD+ATADD.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/6.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MBProgressHUD+ATADD.h"
#import "BSTLoadingView.h"

@implementation MBProgressHUD (ATADD)

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    [BSTLoadingView showMessage:message toView:view];
    return nil;
//    if (view == nil) {
//        view = [UIApplication sharedApplication].keyWindow;
//    }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.text = message;
//    hud.label.font = kFont(15);
//    hud.removeFromSuperViewOnHide = YES;
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.contentColor = [UIColor clearColor];
//    hud.label.textColor = UIColorFromRGBValue(0xf3f3f3);
//    
//    UIImageView *_loadingImgView = [[UIImageView alloc] init];
//    _loadingImgView.frame = CGRectMake(0, 0, 80, 80);
//    _loadingImgView.backgroundColor = [UIColor clearColor];
//     //动态图属性
//    _loadingImgView.animationImages = [self getImageArray];
//    _loadingImgView.animationDuration = 2.0;
//    _loadingImgView.animationRepeatCount = 0;
//    hud.customView = _loadingImgView;
//    [_loadingImgView startAnimating];
//    return hud;
}

+(NSArray *)getImageArray{
    NSMutableArray *imgArray = [NSMutableArray array];

    for (int i = 1; i < 11; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]];
        [imgArray addObject:image];
    }
    return imgArray;
}

+ (void)hideHUDForView:(UIView *)view
{
    [BSTLoadingView hideHUDForView:view];
//    if (view == nil) {
//        view = [UIApplication sharedApplication].keyWindow;
//    }
//    [self hideHUDForView:view animated:YES];
}


@end

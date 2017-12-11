//
//  BSTLoadingView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/11.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTLoadingView : UIView
//动态图
@property (nonatomic, strong) UIImageView *loadingImgView;
//提示文字
@property (nonatomic, strong) UILabel *lbl;


+ (BSTLoadingView *)showMessage:(NSString *)message toView:(UIView *)view ;
+ (void)hideHUDForView:(UIView *)view;

@end

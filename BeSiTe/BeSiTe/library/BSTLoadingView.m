//
//  BSTLoadingView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/11.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BSTLoadingView.h"

@interface BSTLoadingView ()

@end

@implementation BSTLoadingView


- (instancetype)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
     if (self) {
         self.backgroundColor = UIColorFromINTRGBA(0, 0, 0, 0.2);
//         self.backgroundColor = UIColorFromINTRGBA(255, 255, 255, 1);

         [self addSubview:self.loadingImgView];
         [self addSubview:self.lbl];
         [self.loadingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.size.mas_equalTo(CGSizeMake(107, 143));
             make.centerX.centerY.mas_equalTo(self);
         }];
         [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.loadingImgView.bottom).offset(5);
             make.size.mas_equalTo(CGSizeMake(200, 16));
             make.centerX.mas_equalTo(self.centerX);
         }];
     }
     return self;
}

- (UIImageView *)loadingImgView
{
    if(!_loadingImgView){
        _loadingImgView = [[UIImageView alloc] init];
//        _loadingImgView.backgroundColor = [UIColor clearColor];
        //动态图属性
        _loadingImgView.animationImages = [self getImageArray];
        _loadingImgView.animationDuration = 2.0;
        _loadingImgView.contentMode = UIViewContentModeCenter;
        _loadingImgView.animationRepeatCount = 0;
    }
    return _loadingImgView;
}

- (UILabel *)lbl
{
    if(!_lbl){
        _lbl = [[UILabel alloc] init];
        _lbl.font = [UIFont systemFontOfSize:14];
        _lbl.textColor = [UIColor darkGrayColor];
        _lbl.textAlignment = NSTextAlignmentCenter;
    }
    return _lbl;
}
//获取图片数组
- (NSArray *)getImageArray
{
    NSMutableArray *imgArray = [NSMutableArray array];
    
    for (int i = 1; i < 12; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]];
        [imgArray addObject:image];
    }
    return imgArray;
}

+ (BSTLoadingView *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view];
    
    BSTLoadingView * loadingView = [[BSTLoadingView alloc]initWithFrame:view.bounds];
    loadingView.lbl.text = message;
    [view addSubview:loadingView];
    [loadingView.loadingImgView startAnimating];
    return loadingView;
}

+ (void)hideHUDForView:(UIView *)view
{
//    if (view == nil) {
//        view = [UIApplication sharedApplication].keyWindow;
//    }
//    for (UIView *itemView in view.subviews) {
//        if ([itemView isKindOfClass:[BSTLoadingView class]]) {
//            [itemView removeFromSuperview];
//        }
//    }
}


@end

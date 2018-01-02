//
//  BSTLoadingView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/11.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "BSTLoadingView.h"
#import "AppDelegate.h"

@interface BSTLoadingView ()

@end

@implementation BSTLoadingView


- (instancetype)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
     if (self) {
         self.backgroundColor = UIColorFromINTRGBA(0, 0, 0, 0.2);

         [self addSubview:self.loadingImgView];
         [self addSubview:self.lbl];
         self.loadingImgView.frame = CGRectMake(frame.size.width/ 2 - 39, frame.size.height / 2 - 50, 77, 100);
         self.lbl.frame = CGRectMake(frame.size.width/ 2 - 100, frame.size.height / 2 + 50 + 5, 200, 16);
     }
     return self;
}

- (UIImageView *)loadingImgView
{
    if(!_loadingImgView){
        _loadingImgView = [[UIImageView alloc] init];
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
        _lbl.font = [UIFont systemFontOfSize:15];
        _lbl.textColor = [UIColor whiteColor];
        _lbl.textAlignment = NSTextAlignmentCenter;
    }
    return _lbl;
}
//获取图片数组
- (NSArray *)getImageArray
{
    NSMutableArray *imgArray = [NSMutableArray array];
    
    for (int i = 1; i < 13; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]];
        [imgArray addObject:image];
    }
    return imgArray;
}

+ (BSTLoadingView *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) {
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        view = delegate.window;
    }
    [self hideHUDForView:view];
    
    CGRect frame = view.bounds;
    if (frame.size.width > MAXWIDTH) {
        frame.size.width = MAXWIDTH;
    }
    BSTLoadingView * loadingView = [[BSTLoadingView alloc]initWithFrame:frame];
    loadingView.lbl.text = message;
    [view addSubview:loadingView];
    [loadingView.loadingImgView startAnimating];
    return loadingView;
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        view = delegate.window;
    }
    for (UIView *itemView in view.subviews) {
        if ([itemView isKindOfClass:[BSTLoadingView class]]) {
            [itemView removeFromSuperview];
        }
    }
}


@end

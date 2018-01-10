//
//  WebDetailViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/11.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

/**网页*/
@interface WebDetailViewController : ATBaseViewController

@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * gameTitle;

@property (nonatomic,assign) BOOL isOpenRotaion;//是否支持转屏，支持转屏的同时，也代表着打开的是游戏

@property (nonatomic,assign) BOOL isNeedAgreeBtn;//是否需要显示同意按钮
@property (nonatomic,copy) void (^agreeBtnClickBlock)();//点击同意按钮的Block

+(WebDetailViewController *)quickCreateWithUrl:(NSString *)url;//根据URL快速创建webviewController
+(WebDetailViewController *)quickCreateGamePageWithUrl:(NSString *)url;//根据游戏URL快速创建webviewController

+(WebDetailViewController *)quickCreateGamePageWithUrl:(NSString *)url andTitle:(NSString *)title;//根据游戏URL快速创建webviewController



@end

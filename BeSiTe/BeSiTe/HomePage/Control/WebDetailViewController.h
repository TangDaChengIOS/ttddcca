//
//  WebDetailViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/11.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

@interface WebDetailViewController : ATBaseViewController
@property (nonatomic,copy) NSString * url;
@property (nonatomic,assign) BOOL isOpenRotaion;//是否支持转屏

@property (nonatomic,assign) BOOL isNeedAgreeBtn;//是否需要显示同意按钮
@property (nonatomic,copy) void (^agreeBtnClickBlock)();//点击同意按钮的Block

+(WebDetailViewController *)quickCreateWithUrl:(NSString *)url;//根据URL快速创建webviewController
+(WebDetailViewController *)quickCreateGamePageWithUrl:(NSString *)url;//根据游戏URL快速创建webviewController


@end

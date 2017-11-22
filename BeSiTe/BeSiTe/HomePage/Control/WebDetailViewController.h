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
@property (nonatomic,assign) BOOL isOpenRotaion;

+(WebDetailViewController *)quickCreateWithUrl:(NSString *)url;
+(WebDetailViewController *)quickCreateGamePageWithUrl:(NSString *)url;

@end

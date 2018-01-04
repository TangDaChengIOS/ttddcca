//
//  CompanyGameViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 18/1/4.
//  Copyright © 2018年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyGameViewController : UIViewController

@property (nonatomic,copy) NSString * selectCompanyCode;

@property (nonatomic,assign) BOOL isShowSearchResult;//当前是展示搜索结果

@property (nonatomic,assign) BOOL isHaveShowTips;//显示可滑动提示

@property (nonatomic,copy) NSString * searchKey;

-(void)dealData;

@end

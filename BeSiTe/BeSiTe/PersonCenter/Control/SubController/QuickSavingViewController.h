//
//  QuickSavingViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

typedef NS_ENUM(NSInteger,QuickSavingType) {
    QuickSavingType_Bank = 0,//秒存银行
    QuickSavingType_ZFB//秒存支付宝
    
};

/**秒存*/
@interface QuickSavingViewController : ATBaseViewController

@property (nonatomic,assign) QuickSavingType savingType ;

@end

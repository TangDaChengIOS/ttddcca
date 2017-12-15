//
//  ATBaseViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWDrawerAnimator.h"

#import "BSTSingle.h"
#import "RecordTableViewCell.h"
#import "ShowRecordDetailView.h"
#import "BSTNoDataView.h"


@interface ATBaseViewController : UIViewController

@property (nonatomic,assign) BOOL isNeedHiddenNav;

-(void)pushVC:(UIViewController *)viewController;

/**一级页面侧滑显示侧栏菜单*/
- (void)xw_transition;

@end

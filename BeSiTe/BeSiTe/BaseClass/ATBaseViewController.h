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

/**部分页面需要请求数据后展示全部UI*/
-(void)setIsNoDate:(BOOL)isNoDate;


/**是否需要请求个人主账户余额*/
@property (nonatomic,assign) BOOL isNeedRequestPersonBalance;

/**请求个人主账户余额*/
-(void)requestPersonBalance;

/**请求完主账户余额后，刷新界面，父控制器空实现，子控制器实现*/
-(void)refreshPersonBalance;

@end

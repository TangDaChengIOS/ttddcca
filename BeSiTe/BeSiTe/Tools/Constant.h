//
//  Constant.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import "MenuViewController.h"
#import "LoginViewController.h"
#import "MessageViewController.h"

#import "XWInteractiveTransition.h"
#import "UIViewController+XWTransition.h"
#import "RequestManager.h"
#import <YYKit/YYKit.h>
#import "UIView+ATADD.h"
#import "ATNeedBorderView.h"
#import "ATNeedBorderButton.h"
#import "UIBarButtonItem_withBadge.h"
#import <MJRefresh/MJRefresh.h>
#import "BSTSingle.h"
#import "ZZTextInput.h"
#import "VTMagicController+PushVC.h"
#import <Masonry.h>
#import "WebDetailViewController.h"
#import "UIButton+TimerCount.h"
#import "BSTMessageView.h"
#import <MJExtension/NSObject+MJKeyValue.h>
#import "MBProgressHUD+ATADD.h"
#import "RequestCommonData.h"
#import "UIBarButtonItem+NoBadge.h"

/**成功登录通知名*/
#define BSTLoginSuccessNotification @"BSTLoginSuccessNotification"
/**登录失效通知名*/
#define BSTLoginFailueNotification @"BSTLoginFailueNotification"
/**注册成功通知名*/
#define BSTRegisterSuccessNotification @"BSTRegisterSuccessNotification"

/**第一次进入游戏列表页*/
#define kFirstEnterGameListPage @"kFirstEnterGameListPage"

/**存储登录信息的Key*/
#define kSavingUserInfoKey @"kSavingUserInfoKey"

#endif /* Constant_h */

//
//  RegisterSuccessView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShowType) {
    ShowTypeWaitThreeSec = 0,//显示等待3S
    ShowTypeWaitThreeSec_TLD,//显示等待3S，描述两行
    ShowTypeShowTwoSel,//下方两个按钮
    ShowTypeShowOneSel//下方一个按钮
};

typedef NS_ENUM(NSInteger,EventType) {
    EventTypeLeftBtnClick = 0,//左边按钮点击事件
    EventTypeOnlyOneBtnClick = EventTypeLeftBtnClick,//只显示一个按钮点击事件
    EventTypeRightBtnClick//右边按钮点击事件
};

@interface BSTMessageView : UIView

@property (nonatomic,assign) ShowType showType;

@property (nonatomic,copy) NSString * leftBtnTitle;
@property (nonatomic,copy) NSString * rightBtnTitle;
@property (nonatomic,copy) NSString * onlyOneBtnTitle;
@property (nonatomic,copy) NSString * msgTitle;
@property (nonatomic,copy) NSString * msgDetail;
@property (nonatomic,assign) BOOL isSuccessMsg;
@property (nonatomic,assign) BOOL isNotAllowRemoveSelfByTouchSpace;

@property (nonatomic,copy) void (^eventBlock)(EventType eventType);

-(void)showInWindow;
@end

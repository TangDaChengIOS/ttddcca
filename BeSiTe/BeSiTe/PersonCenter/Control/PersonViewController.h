//
//  PersonViewController.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <VTMagic/VTMagicController.h>

typedef NS_ENUM(NSUInteger, PersonCenterItemType) {
    PersonCenterItemTypeMSG = 0,    //信息
    PersonCenterItemTypeBalance, //余额
    PersonCenterItemTypeSaving,    //存款
    PersonCenterItemTypeGeting,   //取款
    PersonCenterItemTypeInOutList, //交易记录
};

/**个人中心SuperViewController*/
@interface PersonViewController : VTMagicController

@end

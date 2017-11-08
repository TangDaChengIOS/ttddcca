//
//  VTMagicController+PushVC.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "VTMagicController+PushVC.h"

@implementation VTMagicController (PushVC)

-(void)pushVC:(UIViewController *)viewController{
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end

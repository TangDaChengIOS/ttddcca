//
//  ATBaseViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

@interface ATBaseViewController ()

@property (nonatomic,strong) UIView * whiteBack;

@end

@implementation ATBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

    if (self.navigationController.viewControllers.count > 1) {
           self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    }
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isNeedHiddenNav) {
        [self.navigationController setNavigationBarHidden:YES];

    }else{
        [self.navigationController setNavigationBarHidden:NO];
    }

    [self refreshPersonBalance];

    if (_isNeedRequestPersonBalance) {
        [self requestPersonBalance];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)pushVC:(UIViewController *)viewController
{
    if (self.navigationController) {
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    }

}
#pragma mark -- 无数据时，用白板盖住
-(void)setIsNoDate:(BOOL)isNoDate{
    if (isNoDate) {
        if (!_whiteBack) {
            [self.view addSubview:self.whiteBack];
        }
    }else{
        if (_whiteBack) {
            [_whiteBack removeFromSuperview];
            _whiteBack = nil;
        }
    }
    
}

-(UIView *)whiteBack{
    if (!_whiteBack) {
        _whiteBack = [[UIView alloc]initWithFrame:self.view.bounds];
        _whiteBack.backgroundColor = kWhiteColor;
    }
    return _whiteBack;
}

/**请求个人主账户余额*/
-(void)requestPersonBalance{
    kWeakSelf
    [RequestManager getWithPath:@"userBalance" params:nil success:^(id JSON, BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [BSTSingle defaultSingle].user.userAmount = [JSON[@"balance"] floatValue];
        [weak_self refreshPersonBalance];
    } failure:^(NSError *error) {
        
    }];
}

/**请求完主账户余额后，刷新界面，父控制器空实现，子控制器实现*/
-(void)refreshPersonBalance{

}

#pragma mark -- 侧滑
- (void)xw_transition{
    XWDrawerAnimatorDirection direction =  XWDrawerAnimatorDirectionLeft;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:LeftMenuWidth];
    animator.toDuration = 0.5;
    animator.backDuration = 0.5;
    animator.parallaxEnable = YES;
    
    MenuViewController * menuVC = [[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    [self xw_presentViewController:menuVC withAnimator:animator];
    __weak typeof(self)weakSelf = self;
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf _xw_back];
    }];
}

- (void)_xw_back{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

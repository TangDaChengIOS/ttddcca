//
//  ATBaseViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATBaseViewController.h"

@interface ATBaseViewController ()
@property (nonatomic,assign) BOOL isHiddenNav;
@end

@implementation ATBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

//    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    _isHiddenNav = self.navigationController.navigationBarHidden;
    if (self.navigationController.viewControllers.count > 1) {
           self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    }
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:_isHiddenNav];
}

-(void)pushVC:(ATBaseViewController *)viewController{
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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

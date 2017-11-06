//
//  RegisterPageTwoViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/23.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RegisterPageTwoViewController.h"
#import "RegisterSuccessView.h"
#import "BankSelectViewController.h"

@interface RegisterPageTwoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewFirstChildView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *boomRightBtn;

@end

@implementation RegisterPageTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

#pragma mark -- subViews
-(void)configSubViews
{
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = kWhiteColor;
    CGFloat height = self.boomRightBtn.maxY + 50;
    self.scrollViewHeightConstraint.constant = height;
    self.scrollView.contentSize = CGSizeMake(MAXWIDTH, height);
    
    CGFloat cornerRadius = 13;
    self.firstBtn.backgroundColor = kWhiteColor;
    [self.firstBtn setTitleColor:UIColorFromINTValue(1, 145, 166) forState:UIControlStateNormal];
    self.firstBtn.layer.cornerRadius = cornerRadius;
    
    self.secBtn.backgroundColor = kWhiteColor;
    [self.secBtn setTitleColor:UIColorFromINTValue(1, 145, 166) forState:UIControlStateNormal];
    self.secBtn.layer.cornerRadius = cornerRadius;
    
    self.threeBtn.layer.borderColor = UIColorFromINTValue(255, 255, 255).CGColor;
    self.threeBtn.layer.cornerRadius = cornerRadius;
    self.threeBtn.layer.borderWidth = 1;
    
}
- (IBAction)finishRegisterBtnClick:(id)sender {
    [RegisterSuccessView show];
}
- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//跳过
- (IBAction)passBtnClick:(id)sender {
    BankSelectViewController * vc = [[BankSelectViewController alloc]init];
//    vc.isHaveOtherData = (arc4random()+1) % 2;
    [self.navigationController pushViewController:vc animated:YES];
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

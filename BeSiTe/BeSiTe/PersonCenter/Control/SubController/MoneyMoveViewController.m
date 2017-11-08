//
//  MoneyMoveViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyMoveViewController.h"

@interface MoneyMoveViewController ()
@property (weak, nonatomic) IBOutlet UIButton *moveToGameBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveToMainBtn;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UIButton *changeCompanyBtn;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation MoneyMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUI:YES];
}

-(void)refreshUI:(BOOL)isLeft
{
    self.moveToMainBtn.backgroundColor = isLeft ?  UIColorFromINTValue(72, 190, 204) : kWhiteColor;
    [self.moveToMainBtn setTitleColor:( isLeft ? kWhiteColor : UIColorFromINTValue(33, 149, 167) ) forState:UIControlStateNormal];
    
    self.moveToGameBtn.backgroundColor = isLeft ? kWhiteColor : UIColorFromINTValue(72, 190, 204)  ;
    [self.moveToGameBtn setTitleColor:( isLeft ?  UIColorFromINTValue(33, 149, 167) :kWhiteColor ) forState:UIControlStateNormal];
    if (isLeft) {
        [self.moveToGameBtn setImage:[KIMAGE(@"common_tab_select_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.moveToGameBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [self.moveToMainBtn setImage:nil forState:UIControlStateNormal];

    }else{
        [self.moveToMainBtn setImage:[KIMAGE(@"common_tab_select_icon")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.moveToMainBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [self.moveToGameBtn setImage:nil forState:UIControlStateNormal];

    }


}


- (IBAction)submitBtnClick:(id)sender {
    [self refreshUI:YES];
}
- (IBAction)changeCompanyBtnClick:(id)sender {
    [self refreshUI:NO];

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

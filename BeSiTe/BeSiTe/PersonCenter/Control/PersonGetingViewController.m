//
//  PersonGetingViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/1.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonGetingViewController.h"
#import "ATTextField.h"

@interface PersonGetingViewController ()
@property (weak, nonatomic) IBOutlet ATTextField *accountTF;
@property (weak, nonatomic) IBOutlet ATTextField *pwdTF;
@property (weak, nonatomic) IBOutlet ATTextField *moneyTF;
@property (weak, nonatomic) IBOutlet ATTextField *cardTF;
@property (weak, nonatomic) IBOutlet ATTextField *cardAdressTF;
@property (weak, nonatomic) IBOutlet UIButton *managerCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@end

@implementation PersonGetingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%lf---%lf",self.view.height - 35,MAXHEIGHT);
    CGFloat viewH = MAXHEIGHT - 35 - 64 - 66- 50;
    _contentViewHeightConstraint.constant = (self.managerCardBtn.maxY < viewH) ? viewH : self.managerCardBtn.maxY + 50;
    _submitBtn.layer.cornerRadius = _managerCardBtn.layer.cornerRadius = 4.0f;
}
- (IBAction)selectBankBtnClick:(id)sender {
}
- (IBAction)submitBtnClick:(id)sender {
}
- (IBAction)managerCardBtnClick:(id)sender {
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

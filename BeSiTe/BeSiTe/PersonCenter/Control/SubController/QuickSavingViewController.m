//
//  QuickSavingViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/7.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "QuickSavingViewController.h"

@interface QuickSavingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLab;
@property (weak, nonatomic) IBOutlet UILabel *bankUserNameLab;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giverNameBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveNameTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giveMoneyBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveMoneyTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *giveNumberBackView;
@property (weak, nonatomic) IBOutlet UITextField *giveNumberTF;

@end

@implementation QuickSavingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = kWhiteColor;
}

- (IBAction)submitClick:(id)sender {
    
}
- (IBAction)copyBankCardClick:(id)sender {
    
}
- (IBAction)copyUserNameClick:(id)sender {
    
}
- (IBAction)helpClick:(id)sender {
    
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

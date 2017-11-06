//
//  RegisterPageOneViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/23.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RegisterPageOneViewController.h"
#import "RegisterPageTwoViewController.h"


@interface RegisterPageOneViewController ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet ATNeedBorderView *pwdSecBackView;
@property (weak, nonatomic) IBOutlet UITextField *pwdSecTF;
@property (weak, nonatomic) IBOutlet UILabel *NotTurePwdLab;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *scrollViewFirstChildView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RegisterPageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

#pragma mark -- subViews
-(void)configSubViews
{
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = kWhiteColor;

    CGFloat cornerRadius = 13;
    self.firstBtn.backgroundColor = kWhiteColor;
    [self.firstBtn setTitleColor:UIColorFromINTValue(1, 145, 166) forState:UIControlStateNormal];
    self.firstBtn.layer.cornerRadius = cornerRadius;

    self.secBtn.layer.borderColor = UIColorFromINTValue(255, 255, 255).CGColor;
    self.secBtn.layer.cornerRadius = cornerRadius;
    self.secBtn.layer.borderWidth = 1;
    
    self.threeBtn.layer.borderColor = UIColorFromINTValue(255, 255, 255).CGColor;
    self.threeBtn.layer.cornerRadius = cornerRadius;
    self.threeBtn.layer.borderWidth = 1;
    
    self.getCodeBtn.layer.borderColor = UIColorFromINTValue(244, 144, 30).CGColor;
    self.getCodeBtn.layer.cornerRadius = 4;
    self.getCodeBtn.layer.borderWidth = 1;
    
    self.pwdSecBackView.layer.borderColor = UIColorFromINTValue(252, 25, 26).CGColor;
    
    self.NotTurePwdLab.hidden = YES;
    
    CGFloat height = self.agreeBtn.maxY + 100;
    self.scrollViewHeightConstraint.constant = height;
    self.scrollView.contentSize = CGSizeMake(MAXWIDTH, height);
}
- (IBAction)registerBtnDidClicked:(id)sender {
    [self.navigationController pushViewController:[[RegisterPageTwoViewController alloc]initWithNibName:@"RegisterPageTwoViewController" bundle:nil] animated:YES];
}

- (IBAction)getCodeBtnDidClicked:(id)sender {
    NSDictionary * dict = @{@"mobile":@"17318037763",
                            @"type":@"1"};
    [RequestManager postWithPath:@"sendSmsCode" params:dict success:^(id JSON) {
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)agreeBtn:(id)sender {
}
- (IBAction)readAgree:(id)sender {
}

- (IBAction)leftBarButtonItemClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}
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

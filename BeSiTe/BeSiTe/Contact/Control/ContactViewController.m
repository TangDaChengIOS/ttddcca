//
//  ContactViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactModel.h"

@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fflxLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;
@property (weak, nonatomic) IBOutlet UILabel *qqLab;
@property (weak, nonatomic) IBOutlet UILabel *wexinLab;
@property (weak, nonatomic) IBOutlet UIImageView *erCodeImageView;

@property (nonatomic,strong) ContactModel * model;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    [self configSub];
    [self requestData];
}
#pragma mark -- viewAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BSTSingle defaultSingle].user) {
        [(UIBarButtonItem_withBadge *)self.navigationItem.rightBarButtonItem setBadgeValue:[BSTSingle defaultSingle].totalNums];
    }
}
-(void)configSub{
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_left_img") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    if ([BSTSingle defaultSingle].user) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem_withBadge alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_right_mail_icon") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"common_navgation_right_img") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }
    
    __weak typeof(self)weakSelf = self;
    
    //侧滑菜单配置
    [self xw_registerToInteractiveTransitionWithDirection:XWInteractiveTransitionGestureDirectionRight transitonBlock:^(CGPoint startPoint){
        [weakSelf xw_transition];
    } edgeSpacing: 80];
    
}

-(void)leftBarButtonItemClick{
    [self xw_transition];
}

-(void)rightBarButtonItemClick
{
    if ([BSTSingle defaultSingle].user) {
        MessageViewController * msgVC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
        [self pushVC:msgVC];
    }else{
        [LoginViewController presentLoginViewController];
    }
}


-(void)requestData{
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"customerConfig" params:nil success:^(id JSON ,BOOL isSuccess) {
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        ContactModel * model = [[ContactModel alloc]init];
        [model mj_setKeyValues:JSON];
        weak_self.model = model;
        [weak_self setDataWithModel:model];
    } failure:^(NSError *error) {
        
    }];
}

-(void)setDataWithModel:(ContactModel *)model{
    self.fflxLab.text = model.hotline.content;
    self.wexinLab.text = model.off_wechat.content;
    self.qqLab.text = model.customer_qq.content;
    self.emailLab.text = model.customer_hotline.content;
    
    [self.erCodeImageView setImageWithURL:[NSURL URLWithString:model.comp_wechat.content] placeholder:KIMAGE(@"8f194ac2f24")];
}


- (IBAction)onLineKefuBtnClick:(id)sender {
    WebDetailViewController * webVC = [WebDetailViewController quickCreateWithUrl:self.model.customer_online.content];
    [self pushVC:webVC];
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

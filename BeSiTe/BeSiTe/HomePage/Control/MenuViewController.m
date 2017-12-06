//
//  MenuViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "XWInteractiveTransition.h"
#import "AppDelegate+Setting.h"
#import "GameListPageViewController.h"
#import "RegisterPageOneViewController.h"
#import "LoginViewController.h"


@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxWidthConstraint;

//顶部导航区域
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet ATNeedBorderButton *exitBtn;

@property (nonatomic,copy) NSArray * secondSectionArr;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _secondSectionArr = @[@"优惠活动",@"客服中心",@"条款规则",@"关于我们"];
    [self configSubViews];
    [self setIfLoginState];
}


-(void)setIfLoginState{
    self.headImageView.contentMode = UIViewContentModeCenter;
    if ([BSTSingle defaultSingle].user) {
        self.registerBtn.hidden = self.loginBtn.hidden = YES;
        self.exitBtn.hidden = NO;
        self.headImageView.image = KIMAGE(@"common_avatar_img");
        self.vipImageView.image = KIMAGE([[BSTSingle defaultSingle].user getVipImageStr]);
    }else{
        self.registerBtn.hidden = self.loginBtn.hidden = NO;
        self.exitBtn.hidden = YES;
        self.headImageView.image = KIMAGE_Ori(@"home_navgraion_loginOut_icon");
        self.vipImageView.image = nil;
    }
}


#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? self.secondSectionArr.count : [BSTSingle defaultSingle].companysArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMenuTableViewCellReuseID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setCellWithModel:[BSTSingle defaultSingle].companysArray[indexPath.row] :(indexPath.row+1) %2];
    }else{
        if (indexPath.row == 0) {
            [cell setCellWith:_secondSectionArr[indexPath.row] isSingleLine:(indexPath.row+1) %2 num:[BSTSingle defaultSingle].activityUnreadNum];
        }else
        {
            [cell setCellWith:_secondSectionArr[indexPath.row] isSingleLine:(indexPath.row+1) %2 num:0];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            GameListPageViewController * menuVC = [[GameListPageViewController alloc]init];
            menuVC.selectIndex = indexPath.item;
            GamesCompanyModel * model = [BSTSingle defaultSingle].companysArray[indexPath.row];
            menuVC.selectCompanyCode = model.companyCode;
            [[AppDelegate getBoomNavigation] pushViewController:menuVC animated:YES];
        }];
    }else
    {
        switch (indexPath.row) {
            case 0://优惠活动
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[AppDelegate getTabBarController]setSelectedIndex:1];
                }];
            }
                break;
            case 1://客服中心
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[AppDelegate getTabBarController]setSelectedIndex:3];
                }];
            }
                break;
            case 2://条款规则
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    WebDetailViewController * webVC = [[WebDetailViewController alloc]init];
                    webVC.url = [BSTSingle defaultSingle].registerAgreementUrl;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [[AppDelegate getBoomNavigation]pushViewController:webVC animated:YES];
                }];

            }
                break;
            case 3://关于我们
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    WebDetailViewController * webVC = [[WebDetailViewController alloc]init];
                    webVC.url = [BSTSingle defaultSingle].aboutUSUrl;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [[AppDelegate getBoomNavigation]pushViewController:webVC animated:YES];
                }];

            }
                break;
            default:
                break;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MenuViewSecitonHeaderID"];
        header.contentView.backgroundColor = UIColorFromINTValue(31, 31, 33);
        if (header.contentView.subviews.count == 0) {
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 24)];
            lab.textColor = UIColorFromINTValue(78, 96, 98);
            lab.font = kFont(12);
            lab.text = @"关于贝斯特";
            [header.contentView addSubview:lab];
        }
        return header;
    }
    return nil;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 24 : 0;
}

#pragma mark -- 配置页面
-(void)configSubViews{
    XWInteractiveTransitionGestureDirection direction =  XWInteractiveTransitionGestureDirectionLeft;
    [self xw_registerBackInteractiveTransitionWithDirection:direction transitonBlock:^(CGPoint startPoint){
        
    } edgeSpacing:0];
    self.headBackView.backgroundColor = kMainColor;
    self.maxWidthConstraint.constant = LeftMenuWidth;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:kMenuTableViewCellReuseID];
    [self.tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"MenuViewSecitonHeaderID"];
}



- (IBAction)registerBtnDidClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [RegisterPageOneViewController presentRegisterController];
//        RegisterPageOneViewController * registerVC = [[RegisterPageOneViewController alloc]initWithNibName:@"RegisterPageOneViewController" bundle:nil];
//        [[AppDelegate getBoomNavigation]pushViewController:registerVC animated:YES];
    }];

}

- (IBAction)loginBtnDidClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [LoginViewController presentLoginViewController];
    }];
}
- (IBAction)exitBtnClick:(id)sender {
    [BSTSingle defaultSingle].user = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:BSTLoginFailueNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [LoginViewController presentLoginViewController];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

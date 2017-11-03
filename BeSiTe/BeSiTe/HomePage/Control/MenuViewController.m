//
//  MenuViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"

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

@property (nonatomic,copy) NSArray * secondSectionArr;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _secondSectionArr = @[@"优惠活动",@"客服中心",@"条款规则",@"关于我们"];
    [self configSubViews];
}

#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? self.secondSectionArr.count : 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMenuTableViewCellReuseID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setCellWith:@"SG" isSingleLine:(indexPath.row+1) %2 cellShowTypeImage:(indexPath.row+1) %2 num:0];
    }else{
        [cell setCellWith:_secondSectionArr[indexPath.row] isSingleLine:(indexPath.row+1) %2 cellShowTypeImage:CellShowTypeImgaeNone num:2];
    }
    return cell;
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
    
}

- (IBAction)loginBtnDidClicked:(id)sender {
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

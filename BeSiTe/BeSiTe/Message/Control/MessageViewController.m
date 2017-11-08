//
//  MessageViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/8.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MessageViewController.h"
#import "UIButton_withBadge.h"
#import "MessageTableViewCell.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton_withBadge *systemMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton_withBadge *personMsgBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) BOOL isSelectSystem;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex = -1;
    _isSelectSystem = YES;
    [self configSubViews];
}
#pragma mark -- tableView delegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMessageTableViewCellReuseID forIndexPath:indexPath];
    if (_selectIndex == indexPath.row) {
        [cell setIsOpenState:YES :_isSelectSystem];
    }else{
        [cell setIsOpenState:NO :NO];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == indexPath.row) {
        _selectIndex = -1;
    }else{
        _selectIndex = indexPath.row;
    }
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == indexPath.row) {
        return _isSelectSystem ? 199 : 244;
    }
    return 54;
}


-(void)refreshUI:(BOOL)isLeft
{
    self.personMsgBtn.backgroundColor = isLeft ?  UIColorFromINTValue(72, 190, 204) : kWhiteColor;
    [self.personMsgBtn setTitleColor:( isLeft ? kWhiteColor : UIColorFromINTValue(33, 149, 167) ) forState:UIControlStateNormal];
    
    self.systemMsgBtn.backgroundColor = isLeft ? kWhiteColor : UIColorFromINTValue(72, 190, 204)  ;
    [self.systemMsgBtn setTitleColor:( isLeft ?  UIColorFromINTValue(33, 149, 167) :kWhiteColor ) forState:UIControlStateNormal];
    if (isLeft) {
        [self.systemMsgBtn setImage:[KIMAGE(@"common_tab_select_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.systemMsgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self.personMsgBtn setImage:nil forState:UIControlStateNormal];
        
    }else{
        [self.personMsgBtn setImage:[KIMAGE(@"common_tab_select_icon")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.personMsgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self.systemMsgBtn setImage:nil forState:UIControlStateNormal];
        
    }
    
    [self.personMsgBtn setBadgeValue:2];
    [self.systemMsgBtn setBadgeValue:100];
}

- (IBAction)systemMsgBtnClick:(id)sender {
    _isSelectSystem = YES;
    _selectIndex = -1;
    [self.tableView reloadData];
}
- (IBAction)personMsgBtn:(id)sender {
    _isSelectSystem = NO;
    _selectIndex = -1;
    [self.tableView reloadData];

}

-(void)configSubViews{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:kMessageTableViewCellReuseID];
    [self refreshUI:YES];
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

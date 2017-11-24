//
//  GameCompanySelectViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/24.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameCompanySelectViewController.h"
#import "GameCompanyTableViewCell.h"

@interface GameCompanySelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation GameCompanySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择游戏平台";
    [self configSubViews];
}

#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BSTSingle defaultSingle].companysArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameCompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kGameCompanyTableViewCellReuseID forIndexPath:indexPath];
    [cell setCellWithCompanyModel:[BSTSingle defaultSingle].companysArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GamesCompanyModel * model = [BSTSingle defaultSingle].companysArray[indexPath.row];
    if (self.finshSelectCompanyBlock) {
        self.finshSelectCompanyBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)configSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[GameCompanyTableViewCell class] forCellReuseIdentifier:kGameCompanyTableViewCellReuseID];
    
    [self.view addSubview:_tableView];
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

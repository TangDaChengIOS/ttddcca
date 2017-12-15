//
//  GameSearchViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameSearchViewController.h"

#define kSearchHistoryKey @"SearchHistoryKey"
@interface GameSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) UIView * clearView;
@end

@implementation GameSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
    [self configSubViews];
    [self readHistoryData];
}


-(void)readHistoryData{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kSearchHistoryKey]) {
        self.dataSource = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults]objectForKey:kSearchHistoryKey]];
        [self.tableView reloadData];
    }

}


#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellSearchPageRuseID" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = UIColorFromINTValue(116, 116, 116);
    cell.textLabel.font = kFont(15);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchBlock) {
        self.searchBlock(self.dataSource[indexPath.item]);
    }
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.dataSource.count > 0) {
        return self.clearView;
    }
    return nil;
}

-(void)configSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellSearchPageRuseID"];
    
    [self.view addSubview:_tableView];
}

-(UIView *)clearView
{
    if (!_clearView) {
        _clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, 100)];
        _clearView.backgroundColor = self.tableView.backgroundColor;
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(MAXWIDTH/2 - 100, 15, 200, 20)];
        [button setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromINTValue(1, 149, 171) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        [_clearView addSubview:button];
    }
    return _clearView;

}


-(void)clearHistory
{
    [self.view endEditing:YES];
    self.searchBar.text = @"";
    [self.dataSource removeAllObjects];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kSearchHistoryKey];
    [self.tableView reloadData];
}


-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"请输入游戏名";
        [_searchBar setImage:KIMAGE_Ori(@"home_search_title_img") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self.dataSource addObject:searchBar.text];
    [[NSUserDefaults standardUserDefaults]setObject:self.dataSource forKey:kSearchHistoryKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (self.searchBlock) {
        self.searchBlock(searchBar.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
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

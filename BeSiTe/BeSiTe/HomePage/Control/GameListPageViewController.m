//
//  GameListPageViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameListPageViewController.h"
#import "GameListPageHeaderView.h"
#import "GameSearchViewController.h"
#include "GamesCanScrollTipsView.h"
#import "CompanyGameViewController.h"

@interface GameListPageViewController ()

@property (nonatomic,strong) GameListPageHeaderView * headerView;//顶部菜单及滚屏通告

@end

@implementation GameListPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubViews];
    [self.headerView setSelectedItem:self.selectIndex];
    [self addSubViewController];
    
    //读取滚屏消息
    [self readNoticesData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readNoticesData) name:kGetNoticesDataSuccessNotification object:nil];
    
}


-(void)addSubViewController
{
    CGFloat headerH = 75 *kPROPORTION + 30;
    
    for (GamesCompanyModel * model in [BSTSingle defaultSingle].companysArray) {
        CompanyGameViewController * gameVC  = [[CompanyGameViewController alloc]init];
        gameVC.selectCompanyCode  = model.companyCode;
        [self addChildViewController:gameVC];
        gameVC.view.frame = CGRectMake(0, headerH, MAXWIDTH, MAXHEIGHT - headerH - 64);
        [self.view addSubview:gameVC.view];
    }
    
    CompanyGameViewController * searchResultVC  = [[CompanyGameViewController alloc]init];
    searchResultVC.isShowSearchResult = YES;
    searchResultVC.selectCompanyCode  = @"SearchCode";
    searchResultVC.view.frame = CGRectMake(0, headerH, MAXWIDTH, MAXHEIGHT - headerH - 64);
    [self addChildViewController:searchResultVC];
    [self.view addSubview:searchResultVC.view];
    
    [self refreshShowViewIndex:self.selectIndex];
}


-(void)refreshShowViewIndex:(NSInteger)index{
    for (int i = 0; i < self.childViewControllers.count; i++) {
        CompanyGameViewController * gameVC  = self.childViewControllers[i];
        if (i == index) {
            gameVC.view.hidden = NO;
            [gameVC dealData];
        }else{
            gameVC.view.hidden = YES;
        }
    }
}

-(void)showSearchResultPageWithKey:(NSString *)key{
    for (int i = 0; i < self.childViewControllers.count -1; i++) {
        CompanyGameViewController * gameVC  = self.childViewControllers[i];
        gameVC.view.hidden = YES;
    }
    
    CompanyGameViewController * gameVC  = [self.childViewControllers lastObject];
    gameVC.view.hidden = NO;
    gameVC.searchKey = key;
    [gameVC dealData];
}



#pragma mark -- 读取通知，滚屏公告
-(void)readNoticesData{
    [self.headerView.scrollTextView  startScrollWithAttributedString:[BSTSingle defaultSingle].notices];
}

#pragma mark -- 页面顶部菜单
-(GameListPageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[GameListPageHeaderView alloc]init];
        kWeakSelf
        _headerView.selectGameCompanyBlock = ^(NSInteger index){
            [weak_self refreshShowViewIndex:index];
        };
        _headerView.gotoSearchBlock = ^(){
            GameSearchViewController * contro = [[GameSearchViewController alloc]init];
            contro.searchBlock = ^(NSString * searchKey){
                [weak_self showSearchResultPageWithKey:searchKey];
            };
            [weak_self pushVC:contro];
        };
    }
    return _headerView;
}

#pragma mark -- subViews
-(void)configSubViews
{
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:KIMAGE_Ori(@"common_navgration_title_ime")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    [self.view addSubview:self.headerView];
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGetNoticesDataSuccessNotification object:nil];
}


@end

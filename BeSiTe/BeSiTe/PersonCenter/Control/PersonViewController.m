//
//  PersonViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "PersonViewController.h"
#import "MessageViewController.h"

#import "PersonMessageViewController.h"
#import "PersonBalanceViewController.h"
#import "PersonSavingViewController.h"
#import "PersonGetingViewController.h"
#import "PersonRecordSearchViewController.h"

#import "OnlyShowImageButton.h"

@interface PersonViewController ()

@property (nonatomic,copy) NSArray * menuList;
@property (nonatomic,strong) UIButton * titleViewBtn;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readUnReadMsgNums) name:kGetUnReadMsgNumsSuccessNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([BSTSingle defaultSingle].user) {
        [_titleViewBtn setImage:KIMAGE_Ori([[BSTSingle defaultSingle].user getVipImageStr]) forState:UIControlStateNormal];
        [_titleViewBtn setTitle:[BSTSingle defaultSingle].user.accountName forState:UIControlStateNormal];
        [(UIBarButtonItem_withBadge *)self.navigationItem.rightBarButtonItem setBadgeValue:[BSTSingle defaultSingle].totalNums];
    }else{
        [_titleViewBtn setImage:nil forState:UIControlStateNormal];
        [_titleViewBtn setTitle:@"未登录" forState:UIControlStateNormal];
    }

    [self readUnReadMsgNums];
    [RequestCommonData getUnReadMsgNums];
}

-(void)readUnReadMsgNums
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([BSTSingle defaultSingle].user) {
            [(UIBarButtonItem_withBadge *)self.navigationItem.rightBarButtonItem setBadgeValue:[BSTSingle defaultSingle].totalNums];
        }
    });
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    OnlyShowImageButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [[OnlyShowImageButton alloc] init];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    NSString * imageStr = [NSString stringWithFormat:@"profile_tab%ld",itemIndex];
    NSString * selImageStr = [NSString stringWithFormat:@"profile_tab%ld_sel",itemIndex];
    menuItem.selectImage = selImageStr;
    menuItem.normalImage = imageStr;
    menuItem.contentMode = UIViewContentModeScaleAspectFit;
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (0 == pageIndex) {
        static NSString *recomId = @"recom.identifier";
        PersonMessageViewController *recomViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
        if (!recomViewController) {
            recomViewController = [[PersonMessageViewController alloc] initWithNibName:@"PersonMessageViewController" bundle:nil];
        }
        return recomViewController;
    }
    else if (1 == pageIndex){
        static NSString *blanceId = @"blance.identifier";
        PersonBalanceViewController *recomViewController = [magicView dequeueReusablePageWithIdentifier:blanceId];
        if (!recomViewController) {
            recomViewController = [[PersonBalanceViewController alloc] init];
        }
        return recomViewController;
    }
    else if (2== pageIndex){
        static NSString *savingId = @"saving.identifier";

        PersonSavingViewController * savingVC = [magicView dequeueReusablePageWithIdentifier:savingId];
        if (!savingVC) {
            savingVC = [[PersonSavingViewController alloc]init];
        }
        return savingVC;
    }
    else if (3== pageIndex){
        static NSString *getingId = @"getting.identifier";
        PersonGetingViewController * gettingVC = [magicView dequeueReusablePageWithIdentifier:getingId];
        if (!gettingVC) {
            gettingVC = [[PersonGetingViewController alloc]initWithNibName:@"PersonGetingViewController" bundle:nil];
        }
        return gettingVC;
    }
    else if (4== pageIndex){
        static NSString *recordId = @"record.identifier";
         PersonRecordSearchViewController * searchVC = [magicView dequeueReusablePageWithIdentifier:recordId];
        if (!searchVC) {
            searchVC = [[PersonRecordSearchViewController alloc]init];
        }
        return searchVC;
    }
    static NSString *gridId = @"grid.identifier";
    PersonMessageViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!gridViewController) {
        gridViewController = [[PersonMessageViewController alloc] initWithNibName:@"PersonMessageViewController" bundle:nil];
    }
    return gridViewController;
}


-(void)setUI{
    [self configNavi];
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor redColor];
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.sliderColor = [UIColor clearColor];
    self.magicView.navigationHeight = 66.f;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    self.magicView.navigationColor = UIColorFromINTValue(8, 85, 99);
    
    [self.magicView reloadData];
}
-(NSArray *)menuList
{
    if (!_menuList) {
        _menuList = @[@" ",@" ",@" ",@" ",@" "];
    }
    return _menuList;
}

#pragma mark -- navi
-(void)configNavi
{
    self.navigationItem.titleView = self.titleViewBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem_withBadge alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_right_mail_icon") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"commmon_navgation_left_img") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    __weak typeof(self)weakSelf = self;
    
    //侧滑菜单配置
    [self xw_registerToInteractiveTransitionWithDirection:XWInteractiveTransitionGestureDirectionRight transitonBlock:^(CGPoint startPoint){
        [weakSelf xw_transition];
    } edgeSpacing: 80];
    
}

-(void)leftBarButtonItemClick{
    [self xw_transition];
}


#pragma mark -- 侧滑
- (void)xw_transition{
    XWDrawerAnimatorDirection direction =  XWDrawerAnimatorDirectionLeft;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:LeftMenuWidth];
    animator.toDuration = 0.5;
    animator.backDuration = 0.5;
    animator.parallaxEnable = YES;
    
    MenuViewController * menuVC = [[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    [self xw_presentViewController:menuVC withAnimator:animator];
    __weak typeof(self)weakSelf = self;
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf _xw_back];
    }];
}

- (void)_xw_back{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightBarButtonItemClick{
    MessageViewController * msgVC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    [self pushVC:msgVC];
}
-(UIButton *)titleViewBtn
{
    if (!_titleViewBtn) {
        _titleViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [_titleViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    }
    return _titleViewBtn;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGetUnReadMsgNumsSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

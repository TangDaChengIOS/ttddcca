//
//  MoneyRecordHomeViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyRecordHomeViewController.h"
#import "MoneyRecordDetailViewController.h"
#import "JiFenDetailViewController.h"

@interface MoneyRecordHomeViewController ()
@property (nonatomic,copy) NSArray * menuList;

@end

@implementation MoneyRecordHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(77, 159, 176) forState:UIControlStateSelected];
        [menuItem setBackgroundImage:[self createImageWithColor:kWhiteColor] forState:UIControlStateSelected];
        [menuItem setBackgroundImage:[self createImageWithColor:RGBCOLOR(72, 190, 204)] forState:UIControlStateNormal];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    if (itemIndex == self.menuList.count - 1) {
        menuItem.titleLabel.numberOfLines = 2;
    }else{
        menuItem.titleLabel.numberOfLines = 1;
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (4 == pageIndex) {
        static NSString *jiFenrecomId = @"Jifen.identifier";
        JiFenDetailViewController *detailViewController = [magicView dequeueReusablePageWithIdentifier:jiFenrecomId];
        if (!detailViewController) {
            detailViewController = [[JiFenDetailViewController alloc] init];
        }
        return detailViewController;
    }
    static NSString *recomId = @"detail.identifier";
    MoneyRecordDetailViewController *detailViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
    if (!detailViewController) {
        detailViewController = [[MoneyRecordDetailViewController alloc] init];
    }
    detailViewController.detailControlType = pageIndex;
    return detailViewController;
 
}



-(void)setUI{
    [self configNavi];
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.sliderColor = [UIColor clearColor];
    self.magicView.navigationHeight = 50;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    
    [self.magicView reloadData];
}
-(NSArray *)menuList
{
    if (!_menuList) {
        _menuList = @[@"取款",@"存款",@"转账",@"优惠",@"积分",@"推荐\n礼金"];
    }
    return _menuList;
}

#pragma mark -- navi
-(void)configNavi
{
    self.navigationItem.title = @"交易记录查询";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
}

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 根据颜色获取图片
- (UIImage *)createImageWithColor:(UIColor *)color
{
    //图片尺寸
    CGRect rect = CGRectMake(0, 0, MAXWIDTH / self.menuList.count, 50);
    //填充画笔
    UIGraphicsBeginImageContext(rect.size);
    //根据所传颜色绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    //显示区域
    CGContextFillRect(context, rect);
    // 得到图片信息
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //消除画笔
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

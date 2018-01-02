//
//  ZFBHelpViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 18/1/1.
//  Copyright © 2018年 Tang. All rights reserved.
//

#import "ZFBHelpViewController.h"

@interface ZFBHelpViewController ()
@property (nonatomic,strong) UIImageView * helpImageView;
@end

@implementation ZFBHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"秒存 支付宝";
    
    _helpImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _helpImageView.image = KIMAGE(@"zfbHelpImage");
    
    _helpImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _helpImageView.autoresizesSubviews = YES;
    
    _helpImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self.view addSubview:_helpImageView];
    

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

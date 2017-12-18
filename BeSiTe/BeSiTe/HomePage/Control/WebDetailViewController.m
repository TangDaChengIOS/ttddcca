//
//  WebDetailViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/11.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "WebDetailViewController.h"
#import "AppDelegate.h"

@interface WebDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic,strong) UIView * agreeBtnBackView;//部分显示协议的页面，需要同意按钮
@end

@implementation WebDetailViewController

-(UIView *)agreeBtnBackView
{
    if (!_agreeBtnBackView) {
        _agreeBtnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, MAXHEIGHT - 64 - 76, MAXWIDTH, 76)];
        _agreeBtnBackView.backgroundColor = kWhiteColor;
        
        ATNeedBorderButton * agreeBtn = [[ATNeedBorderButton alloc]initWithFrame:CGRectMake(16, 18, MAXWIDTH - 52, 40)];
        [agreeBtn setTitle:@"同 意" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        agreeBtn.backgroundColor = UIColorFromRGBValue(0x1AAE6A);
        [agreeBtn addTarget:self action:@selector(agreeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtnBackView addSubview:agreeBtn];
    }
    return _agreeBtnBackView;
}


-(void)agreeBtnDidClick
{
    if (self.agreeBtnClickBlock) {
        self.agreeBtnClickBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加载中...";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:KIMAGE_Ori(@"navgartion_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];

    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT - 64)];
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = kWhiteColor;

    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    if (_isOpenRotaion) {
        [self openRotaion];
    }
}

-(void)setIsNeedAgreeBtn:(BOOL)isNeedAgreeBtn
{
    _isNeedAgreeBtn = isNeedAgreeBtn;
    if (_isNeedAgreeBtn) {
        [self.view addSubview:self.agreeBtnBackView];
        self.webView.height -= self.agreeBtnBackView.height;
    }
}

-(void)leftBarButtonItemClick{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}


#pragma mark -- 旋转屏幕相关设置
-(void)openRotaion
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isCanRotationWindow = YES;

}
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//页面是否支持自动转屏
- (BOOL)shouldAutorotate
{
    return YES;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat bigger = MAXWIDTH > MAXHEIGHT ? MAXWIDTH : MAXHEIGHT;
    CGFloat smaller = MAXWIDTH < MAXHEIGHT ? MAXWIDTH : MAXHEIGHT;

    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _webView.frame = CGRectMake(0, 0, smaller, bigger - 64);
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _webView.frame = CGRectMake(0, 0, bigger, smaller);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isCanRotationWindow = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];

}

+(WebDetailViewController *)quickCreateWithUrl:(NSString *)url{
    WebDetailViewController * webVC = [[WebDetailViewController alloc]init];
    webVC.url = url;
    webVC.hidesBottomBarWhenPushed = YES;
    return webVC;
}
+(WebDetailViewController *)quickCreateGamePageWithUrl:(NSString *)url{
    WebDetailViewController * webVC = [[WebDetailViewController alloc]init];
    webVC.url = url;
    webVC.isOpenRotaion = YES;
    webVC.hidesBottomBarWhenPushed = YES;
    return webVC;
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

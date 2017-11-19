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
@end

@implementation WebDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;

    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self openRotaion];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"111111");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"2222222");
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
        _webView.frame = CGRectMake(0, 0, smaller, bigger);
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

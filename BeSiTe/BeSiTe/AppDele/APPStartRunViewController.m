//
//  APPStartRunViewController.m
//  LingYou
//
//  Created by TDC on 2017/6/12.
//  Copyright © 2017年 Mars. All rights reserved.
//

#import "APPStartRunViewController.h"

@interface APPStartRunViewController ()

@property(nonatomic,strong)UIScrollView * scrollView;

@end

@implementation APPStartRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
 //   _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    [self addSubViewToScr];

}
-(void)addSubViewToScr
{
    int total = 3;
    for (int i = 1; i <= total; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH * (i - 1), 0, MAXWIDTH, MAXHEIGHT)];
        imageView.image =
        [UIImage imageNamed:[NSString stringWithFormat:@"APPStartRun%d.jpg",i]];
        [_scrollView addSubview:imageView];
        if (i == total) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                NSLog(@"bie");
                if (self.finishBlock) {
                    self.finishBlock();
                }

            }];
            [imageView addGestureRecognizer:tap];
        }
        
    }
    _scrollView.contentSize = CGSizeMake(total * MAXWIDTH , MAXHEIGHT);
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

//
//  ActivityViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];

}
-(void)requestData{

    NSDictionary * dict = @{@"pageNo":@"1",
                            @"pageSize":@"10"};
    [RequestManager getManagerDataWithPath:@"favActivity" params:dict success:^(id JSON) {
        NSLog(@"%@",JSON);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);

    }];
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

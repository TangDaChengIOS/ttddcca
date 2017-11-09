//
//  ActivityViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ActivityViewController.h"
#import "OnlyShowTimeTableViewCell.h"
#import "ActivityTableViewCell.h"

@interface ActivityViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView * tableView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    
}


#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2  == 0) {
        OnlyShowTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOnlyShowTimeTableViewCellReuseID forIndexPath:indexPath];
        return cell;
    }
    else{
        ActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kActivityTableViewCellReuseID forIndexPath:indexPath];
        [cell setIsOpenState:NO];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2  == 0) {
        return 38;
    }
    else{
        return 65;
    }
}



-(void)configSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT - 64 -49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[OnlyShowTimeTableViewCell class] forCellReuseIdentifier:kOnlyShowTimeTableViewCellReuseID];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:nil] forCellReuseIdentifier:kActivityTableViewCellReuseID];
    [self.view addSubview:_tableView];
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

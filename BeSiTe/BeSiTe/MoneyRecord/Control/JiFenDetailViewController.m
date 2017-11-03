//
//  JiFenDetailViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/31.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "JiFenDetailViewController.h"
#import "RecordTableViewCell.h"

@interface JiFenDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RecordTableViewCell * headerView_top;
@property (nonatomic,strong) RecordTableViewCell * headerView_boom;

@property (nonatomic,strong) UITableView * tableView_top;
@property (nonatomic,strong) UITableView * tableView_boom;

@end

@implementation JiFenDetailViewController

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
    RecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCellReuseID forIndexPath:indexPath];
    if (tableView == _tableView_top) {
        cell.cellType =  RecordCellType_CunKuan;
    }else{
        cell.cellType =  RecordCellType_YouHui;
    }
    [cell setCell];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MenuViewSecitonHeaderID"];
//        header.contentView.backgroundColor = UIColorFromINTValue(31, 31, 33);
//        if (header.contentView.subviews.count == 0) {
//            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 24)];
//            lab.textColor = UIColorFromINTValue(78, 96, 98);
//            lab.font = kFont(12);
//            lab.text = @"关于贝斯特";
//            [header.contentView addSubview:lab];
//        }
//        return header;
//    }
//    return nil;;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return section == 1 ? 24 : 0;
//}


-(void)configSubViews
{
    CGFloat tableViewH  = (MAXHEIGHT - 64 - 50 - (24 + 28)*2 ) /2;
    
//上部分标题
    UILabel * topLab = [self createLabWithFrame:CGRectMake(0, 0, MAXWIDTH, 24) andTitle:@"兑换记录"];
    [self.view addSubview:topLab];
    
//上部分列表头
    _headerView_top = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView_top.top = 24;
    _headerView_top.cellType = RecordCellType_CunKuan;
    [_headerView_top setTopCellWithVCType:RecordDetailControlType_JiFenTop];
    [self.view addSubview:_headerView_top];
    
//上部分tableview
    _tableView_top = [[UITableView alloc]initWithFrame:CGRectMake(0, 52, MAXWIDTH, tableViewH) style:UITableViewStylePlain];
    _tableView_top.delegate = self;
    _tableView_top.dataSource = self;
    [_tableView_top registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordTableViewCellReuseID];
    [self.view addSubview:_tableView_top];
    
//下部分标题
    UILabel * boomLab = [self createLabWithFrame:CGRectMake(0, _tableView_top.maxY, MAXWIDTH, 24) andTitle:@"获取记录"];
    [self.view addSubview:boomLab];
    
//下部分列表头
    _headerView_boom = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView_boom.top = boomLab.maxY;
    _headerView_boom.cellType = RecordCellType_YouHui;
    [_headerView_boom setTopCellWithVCType:RecordDetailControlType_JiFenBoom];
    [self.view addSubview:_headerView_boom];

//下部分tableview
    _tableView_boom = [[UITableView alloc]initWithFrame:CGRectMake(0, boomLab.maxY + 28, MAXWIDTH, tableViewH) style:UITableViewStylePlain];
    _tableView_boom.delegate = self;
    _tableView_boom.dataSource = self;
    [_tableView_boom registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordTableViewCellReuseID];
    [self.view addSubview:_tableView_boom];
}
//共用方法创建lab
-(UILabel *)createLabWithFrame:(CGRect)frame andTitle:(NSString *)title{
    UILabel * lable = [[UILabel alloc]initWithFrame:frame];
    lable.backgroundColor = UIColorFromINTValue(192, 238, 244);
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = kFont(12);
    lable.textColor = UIColorFromINTValue(52, 152, 165);
    lable.text = title;
    return lable;
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

//
//  MoneyRecordDetailViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/31.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "MoneyRecordDetailViewController.h"
#import "RecordTableViewCell.h"

@interface MoneyRecordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RecordTableViewCell * headerView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) NSInteger page;
@end

@implementation MoneyRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    kWeakSelf
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        weak_self.page += 1;
        [weak_self requestData];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
-(void)requestData{
    switch (_detailControlType) {
        case RecordDetailControlType_QuKuan:
            [self requestDataForQuKuan];
            break;
        case RecordDetailControlType_CunKuan:
            [self requestDataForCunKuan];
            break;
        case RecordDetailControlType_ZhuanZhang:
            [self requestDataForZhuanZhang];
            break;
        case RecordDetailControlType_YouHui:
            [self requestDataForYouHui];
            break;
            
        case RecordDetailControlType_TJLJ:
            [self requestDataForTuiJianLiJin];
            break;
        default:
            [self requestDataForQuKuan];
            break;
    }
 
}

-(NSDictionary *)para{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[BSTSingle defaultSingle].moneyRecordSearchPara];
    [dict setValue:@(self.page) forKey:@"pageNo"];
    [dict setValue:@(20) forKey:@"pageSize"];
    return dict;
}


#pragma mark -- 请求取款数据
-(void)requestDataForQuKuan{
    [RequestManager getWithPath:@"getUserWithdrawInfos" params:[self para] success:^(id JSON) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 请求存款数据
-(void)requestDataForCunKuan{
    [RequestManager getWithPath:@"" params:[self para] success:^(id JSON) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 请求转账数据
-(void)requestDataForZhuanZhang{
    [RequestManager getWithPath:@"" params:[self para] success:^(id JSON) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 请求优惠数据
-(void)requestDataForYouHui{
    [RequestManager getWithPath:@"" params:[self para] success:^(id JSON) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 请求推荐礼金数据
-(void)requestDataForTuiJianLiJin{
    [RequestManager getWithPath:@"" params:[self para] success:^(id JSON) {
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- 设置列表 标题栏，因界面复用，根据宏展示不同样式
-(void)setDetailControlType:(RecordDetailControlType)detailControlType{
    _detailControlType = detailControlType;
    dispatch_async(dispatch_get_main_queue(), ^{
        _headerView.cellType = [self getCellType:nil];
        [_headerView setTopCellWithVCType:_detailControlType];

        [_tableView reloadData];
    });

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
    cell.cellType = [self getCellType:indexPath];
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
-(RecordCellType)getCellType:(NSIndexPath *)indexPath{
    switch (_detailControlType) {
        case RecordDetailControlType_QuKuan:
        {
            return RecordCellType_QuKuan;
        }
            break;
        case RecordDetailControlType_CunKuan:
        {
            return RecordCellType_CunKuan;

        }
            break;
        case RecordDetailControlType_ZhuanZhang:
        {
            return RecordCellType_CunKuan;

        }
            break;
        case RecordDetailControlType_YouHui:
        {
            return RecordCellType_YouHui;

        }
            break;

        case RecordDetailControlType_TJLJ:
        {
            return RecordCellType_CunKuan;

        }
            break;
        default:
            return RecordCellType_CunKuan;
            break;
    }
}


-(void)configSubViews{
    _headerView = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    [self.view addSubview:_headerView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 28, MAXWIDTH, MAXHEIGHT - 64 -28 - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordTableViewCellReuseID];
    
    [self.view addSubview:_tableView];
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

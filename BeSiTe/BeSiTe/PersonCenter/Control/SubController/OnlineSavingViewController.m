//
//  OnlineSavingViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/27.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "OnlineSavingViewController.h"
#import "OnlineSavingTableViewCell.h"

@interface OnlineSavingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITextField * moneyTF;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,strong) UIView * boomView;
@property (nonatomic,strong) UIButton * agreeBtn;
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation OnlineSavingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线存款";
    _selectedIndex = -1;
    [self configSubViews];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -- 请求数据
-(void)requestData
{
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"payChannel" params:nil success:^(id JSON ,BOOL isSuccess) {
        NSLog(@"%@",JSON);
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        weak_self.dataSource = [OnlinePayModel jsonToArray:JSON];
        [weak_self.tableView reloadData];
    } failure:^(NSError *error) {
    
    }];
}

#pragma mark -- tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnlineSavingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOnlineSavingTableViewCellReuseID forIndexPath:indexPath];
    [cell setCellWithModel:self.dataSource[indexPath.row]];
    if (indexPath.row == _selectedIndex) {
        [cell setCellSelected];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnlinePayModel * model = self.dataSource[indexPath.row];
    if (model.status == 1) {
        _selectedIndex = indexPath.row;
        [self.tableView reloadData];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.dataSource.count > 0) {
        return self.boomView;
    }
    return nil;
}

-(void)configSubViews
{
    UIView * topBackView = [[UIView alloc]init];
    topBackView.backgroundColor = UIColorFromINTValue(246, 246, 246);
    [self.view addSubview:topBackView];
    
    UILabel * leftLab = [[UILabel alloc]init];
    leftLab.textColor = UIColorFromRGBValue(0xda2a2c);
    leftLab.font = kFont(14);
    leftLab.text = @"金额";
    [topBackView addSubview:leftLab];
    
    UILabel * centerLab = [[UILabel alloc]init];
    centerLab.textColor = UIColorFromRGBValue(0xbababa);
    centerLab.font = kFont(14);
    centerLab.text = @"¥";
    [topBackView addSubview:centerLab];
    
    _moneyTF = [[UITextField alloc]init];
    _moneyTF.placeholder = @"请输入存款数额";
    _moneyTF.font = kFont(14);
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    [topBackView addSubview:_moneyTF];
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(@0);
        make.height.mas_equalTo(@40);
    }];
    
    [_moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@(MAXWIDTH / 2 - 20));
        make.trailing.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
        make.top.mas_equalTo(@10);
    }];
    [centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(_moneyTF);
        make.trailing.equalTo(_moneyTF.mas_leading).offset(-10);
    }];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(_moneyTF);
        make.trailing.equalTo(centerLab.mas_leading).offset(-10);
    }];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[OnlineSavingTableViewCell class] forCellReuseIdentifier:kOnlineSavingTableViewCellReuseID];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackView.mas_bottom);
        make.trailing.leading.bottom.mas_equalTo(self.view);
    }];
}

-(UIView *)boomView{
    if (!_boomView) {
        _boomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, 100)];
        _boomView.backgroundColor = kWhiteColor;
        
        _agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 9, 40, 40)];
        [_agreeBtn setImage:KIMAGE_Ori(@"profile_onlinePay_btn_img") forState:UIControlStateNormal];
        [_agreeBtn setImage:KIMAGE_Ori(@"profile_onlinePay_btn_select_img") forState:UIControlStateSelected];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [_boomView addSubview:_agreeBtn];
        
        UIButton * agreementBtn = [[UIButton alloc]initWithFrame:CGRectMake(_agreeBtn.maxX , 9, MAXWIDTH - _agreeBtn.maxX - 15, 40)];
        [agreementBtn setAttributedTitle:[self getAttributeString] forState:UIControlStateNormal];
        [agreementBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [agreementBtn addTarget:self action:@selector(readAgreementBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_boomView addSubview:agreementBtn];
        
        UIView * boomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 57, MAXWIDTH, 1)];
        boomLine.backgroundColor = UIColorFromINTValue(246, 246, 246);
        [_boomView addSubview:boomLine];
        
        UIButton * comitBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, boomLine.maxY + 14, MAXWIDTH - 24, 40)];
        comitBtn.backgroundColor = UIColorFromRGBValue(0xfd8a6d);
        [comitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [comitBtn setTitle:@"立即存款" forState:UIControlStateNormal];
        comitBtn.layer.cornerRadius = 4.0f;
        [comitBtn addTarget:self action:@selector(comitBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [_boomView addSubview:comitBtn];
    }
    return _boomView;
}

#pragma mark -- Buttons Event
-(void)agreeBtnClick{
    _agreeBtn.selected = !_agreeBtn.selected;
}


-(void)readAgreementBtnClick{
    WebDetailViewController * webVC = [WebDetailViewController quickCreateWithUrl:[BSTSingle defaultSingle].registerAgreementUrl];
    webVC.isNeedAgreeBtn = YES;
    kWeakSelf
    webVC.agreeBtnClickBlock = ^(){
        weak_self.agreeBtn.selected = YES;
    };
    [self pushVC:webVC];
}

-(void)comitBtnClick
{
    if (![ZZTextInput onlyInputTheNumber:self.moneyTF.text]) {
        TTAlert(@"请输入正确的存款数额");
        return;
    }
    if (_selectedIndex == -1) {
        TTAlert(@"请选择一种支付方式");
        return;
    }
    OnlinePayModel * model = self.dataSource[_selectedIndex];
    NSInteger saveMoney = [self.moneyTF.text integerValue];
    if (saveMoney > [model.maxAmount integerValue] || saveMoney < [model.minAmount integerValue]) {
        NSString *sourceString = [NSString stringWithFormat:@"%@要求:最低%@元 最高%@元",model.payName,model.minAmount,model.maxAmount];
        TTAlert(sourceString);
        return;
    }
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setValue:model.payCode forKey:@"payType"];
    [mDict setValue:self.moneyTF.text forKey:@"amount"];
    if (self.agreeBtn.selected) {
        [mDict setValue:@"1" forKey:@"isApplyDiscnt"];
    }else{
        [mDict setValue:@"0" forKey:@"isApplyDiscnt"];
    }
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"pay" params:mDict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        NSLog(@"%@",JSON);
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        NSString * payUrl = JSON[@"payUrl"];
        WebDetailViewController * webVC = [WebDetailViewController quickCreateWithUrl:payUrl];
        [weak_self pushVC:webVC];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
    }];
}


-(NSAttributedString *)getAttributeString
{
    NSString *sourceString = @"申请老虎机存款红利接受《优惠协议》条款";
    NSRange  range1 = [sourceString rangeOfString:@"接受" options:NSLiteralSearch];
    NSRange  range2 = [sourceString rangeOfString:@"条款" options:NSLiteralSearch];
    

    NSRange range = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
            
    NSMutableAttributedString * mAStr = [[NSMutableAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x707070),NSFontAttributeName:kFont(14)}];
            
    NSAttributedString * aStr = [[NSAttributedString alloc]initWithString:[sourceString substringWithRange:range] attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x64b151),NSFontAttributeName:kFont(14)}];
            
    [mAStr replaceCharactersInRange:range withAttributedString:aStr];
    return mAStr;
   
    
}


-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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

//
//  RecordExchangeView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/29.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RecordExchangeView.h"

@interface RecordExchangeView (){
    BOOL _isRequested;
}

@property (nonatomic,strong) UILabel * recordLab;
@property (nonatomic,strong) UITextField * moneyTF;
@property (nonatomic,strong) UILabel * tipsLab;

@end

@implementation RecordExchangeView

-(instancetype)init
{
    if (self = [super init]) {
        [self configSubViews];
    }
    return self;
}


-(void)configSubViews
{
    CGFloat whiteBack_W = MAXWIDTH - 60 * kPROPORTION;
    UIView * whiteBack = [[UIView alloc]initWithFrame:CGRectMake(30*kPROPORTION, (MAXHEIGHT - 274)/2, whiteBack_W, 274)];
    whiteBack.backgroundColor = kWhiteColor;
    whiteBack.layer.cornerRadius = 4;
    [self addSubview:whiteBack];
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 100, 15)];
    lab.text = @"积分兑换";
    lab.textColor = UIColorFromRGBValue(0x6a6a6a);
    lab.font = kFont(15);
    [whiteBack addSubview:lab];
    
    UIButton * onlyShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(whiteBack_W / 2 - 75, lab.maxY + 14, 75, 20)];
    [onlyShowBtn setImage:KIMAGE(@"profile_integral_icon") forState:UIControlStateNormal];
    [onlyShowBtn setTitle:@"我的积分" forState:UIControlStateNormal];
    [onlyShowBtn setTitleColor:UIColorFromINTValue(190, 190, 190) forState:UIControlStateNormal];
    onlyShowBtn.titleLabel.font = kFont(14);
    [onlyShowBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [whiteBack addSubview:onlyShowBtn];
    
    _recordLab = [[UILabel alloc]initWithFrame:CGRectMake(whiteBack_W / 2 + 10, lab.maxY + 14, whiteBack_W / 2 - 20, 20)];
    _recordLab.textColor = UIColorFromINTValue(190, 190, 190);
    _recordLab.font = kFont(14);
    [whiteBack addSubview:_recordLab];

    _moneyTF = [self createTextFieldWithFrame:CGRectMake(16, onlyShowBtn.maxY + 12, whiteBack_W - 32, 38)];
    _moneyTF.placeholder = @"请填写需要兑换的积分数";
    _moneyTF.textAlignment = NSTextAlignmentCenter;
    _moneyTF.leftViewMode = UITextFieldViewModeNever;
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    [whiteBack addSubview:_moneyTF];
    
    UIButton * allBtn = [[UIButton alloc]initWithFrame:CGRectMake(whiteBack_W - 28 - 40, onlyShowBtn.maxY + 13, 40, 36)];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [allBtn setTitleColor:UIColorFromINTValue(1, 146, 219) forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    allBtn.backgroundColor = kWhiteColor;
    [whiteBack addSubview:allBtn];
    
    _tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(16, _moneyTF.maxY + 15,  whiteBack_W - 32, 15)];
    _tipsLab.textColor = UIColorFromRGBValue(0xcccccc);
    _tipsLab.font = kFont(14);
    _tipsLab.textAlignment = NSTextAlignmentCenter;
    [whiteBack addSubview:_tipsLab];
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, _tipsLab.maxY + 15, whiteBack_W - 32, 40)];
    saveBtn.backgroundColor = UIColorFromINTValue(99, 162, 83);
    [saveBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 4.0f;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:saveBtn];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, saveBtn.maxY + 10, whiteBack_W - 32, 40)];
    cancelBtn.layer.borderColor = UIColorFromINTValue(99, 162, 83).CGColor;
    cancelBtn.layer.borderWidth = 1.0f;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromINTValue(99, 162, 83) forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 4.0f;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:cancelBtn];
    
}
//- (void)didMoveToWindow
- (void)didMoveToSuperview
{
    if (_isRequested) {
        return;
    }
    _isRequested = YES;
    kWeakSelf
    [MBProgressHUD showMessage:@"数据加载中..." toView:nil];
    [RequestManager getWithPath:@"getUserScore" params:nil success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];

        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        weak_self.recordLab.text = JSON[@"postring"];
        weak_self.tipsLab.text = JSON[@"ruleDesc"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}

+(void)showWithFinshBlock:(void (^)())completeBlock{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    RecordExchangeView * view = [[RecordExchangeView alloc]init];
    view.completeBlock = completeBlock;
    [window addSubview:view];
}


-(void)allBtnClick{
    NSArray * arr = [self.recordLab.text componentsSeparatedByString:@"."];
    self.moneyTF.text = arr[0];
}

-(void)saveBtnClick{
    if (![ZZTextInput onlyInputTheNumber:self.moneyTF.text]) {
        TTAlert(@"请输入正确的积分数");
        return;
    }
    if ([self.moneyTF.text integerValue] > [self.recordLab.text integerValue]) {
        TTAlert(@"您当前输入兑换积分数大于剩余积分数，请重新输入！");
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postWithPath:@"completeUserInfo" params:@{@"userName":self.moneyTF.text} success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];

        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"积分兑换成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self removeFromSuperview];
    if (self.completeBlock) {
        self.completeBlock();
    }
}

-(void)cancelBtnClick{
    [self removeFromSuperview];
}



@end

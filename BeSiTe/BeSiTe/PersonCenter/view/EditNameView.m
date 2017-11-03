//
//  EditNameView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "EditNameView.h"

@interface EditNameView ()

@property (nonatomic,strong) UITextField * nameTF;

@end

@implementation EditNameView

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
    UIView * whiteBack = [[UIView alloc]initWithFrame:CGRectMake(30*kPROPORTION, (MAXHEIGHT - 254)/2, whiteBack_W, 254)];
    whiteBack.backgroundColor = kWhiteColor;
    whiteBack.layer.cornerRadius = 4;
    [self addSubview:whiteBack];
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, 100, 15)];
    lab.text = @"填写姓名";
    lab.textColor = UIColorFromRGBValue(0x6a6a6a);
    lab.font = kFont(15);
    [whiteBack addSubview:lab];
    
    UITextField * nameTF = [self createTextFieldWithFrame:CGRectMake(16, lab.maxY + 25, whiteBack_W - 32, 38)];
    nameTF.placeholder = @"请填写真实姓名";
    nameTF.textAlignment = NSTextAlignmentCenter;
    nameTF.leftViewMode = UITextFieldViewModeNever;
    [whiteBack addSubview:nameTF];
    
    UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(16, nameTF.maxY + 15,  whiteBack_W - 32, 15)];
    lab2.text = @"此姓名将作为提款依据，不能修改";
    lab2.textColor = UIColorFromRGBValue(0xcccccc);
    lab2.font = kFont(12);
    lab2.textAlignment = NSTextAlignmentCenter;
    [whiteBack addSubview:lab2];
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, lab2.maxY + 15, whiteBack_W - 32, 40)];
    saveBtn.backgroundColor = UIColorFromINTValue(99, 162, 83);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
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
+(void)show{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    EditNameView * view = [[EditNameView alloc]init];
    [window addSubview:view];
}

-(void)saveBtnClick{
    
}


-(void)cancelBtnClick{
    
}


@end

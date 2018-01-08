//
//  UpdateVersionView.m
//  BeSiTe
//
//  Created by 汤达成 on 18/1/8.
//  Copyright © 2018年 Tang. All rights reserved.
//

#import "UpdateVersionView.h"
#import "ATNeedBorderButton.h"

@interface UpdateVersionView ()
@property (nonatomic,strong) UIImageView * topImage;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) UILabel * contentLab;
@property (nonatomic,strong) ATNeedBorderButton * updateBtn;
@property (nonatomic,strong) ATNeedBorderButton * cancelBtn;

@end

@implementation UpdateVersionView


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
    whiteBack.frame = CGRectMake(30*kPROPORTION, (MAXHEIGHT - 254)/2, whiteBack_W, 254);
    
    _topImage = [[UIImageView alloc]initWithFrame:CGRectMake(MAXWIDTH /2 - 33, 0, 66, 60)];
    _topImage.image = KIMAGE(@"icon_updated");
    [self addSubview:_topImage];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, whiteBack_W - 20, 25)];
    _titleLab.textColor = UIColorFromINTValue(0, 145, 166);
    _titleLab.font = kFont(15);
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [whiteBack addSubview:_titleLab];
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(10, _titleLab.maxY , whiteBack_W - 20, 1)];
    _line.backgroundColor = UIColorFromINTValue(0, 145, 166);
    [whiteBack addSubview:_line];
    
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(38*kPROPORTION, _titleLab.maxY + 20, whiteBack_W - 48 * kPROPORTION, 15)];
    _contentLab.textColor = UIColorFromINTValue(170, 170, 170);
    _contentLab.font = kFont(14);
    _contentLab.numberOfLines = 0;
    [whiteBack addSubview:_contentLab];
    
    _updateBtn= [[ATNeedBorderButton alloc]initWithFrame:CGRectMake(16, _contentLab.maxY + 20, whiteBack_W - 32, 40)];
    _updateBtn.backgroundColor = UIColorFromINTValue(0, 145, 166);
    [_updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [_updateBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_updateBtn addTarget:self action:@selector(updateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:_updateBtn];
    
    _cancelBtn= [[ATNeedBorderButton alloc]initWithFrame:CGRectMake(16, _updateBtn.maxY + 10, whiteBack_W - 32, 40)];
    _cancelBtn.layer.borderColor = UIColorFromINTValue(0, 145, 166).CGColor;
    [_cancelBtn setTitle:@"暂不升级" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:UIColorFromINTValue(0, 145, 166) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:_cancelBtn];
    
}

-(void)setModel:(CheckIfNeedUpdateModel *)model
{
    _model = model;
    NSString * title = [NSString stringWithFormat:@"新版本%@全新上线",model.verNo];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:kFont(15)}];
    _line.width = titleSize.width;
    _line.centerX = _titleLab.centerX;
    _titleLab.text = title;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;//行间距
    NSDictionary * dict = @{NSFontAttributeName:kFont(14),NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColorFromINTValue(170, 170, 170)};
    CGSize size =[model.updateContent sizeWithAttributes:dict];
    
    _contentLab.height = size.height;
    _contentLab.attributedText = [[NSAttributedString alloc]initWithString:model.updateContent attributes:dict];
    
    _updateBtn.mj_y = _contentLab.maxY + 20;
    if (model.type == 1) {
        _cancelBtn.hidden = YES;
        whiteBack.height = _updateBtn.maxY + 20;
    }else{
        _cancelBtn.mj_y = _updateBtn.maxY + 10;
        whiteBack.height = _cancelBtn.maxY + 20;
    }
    whiteBack.centerY = self.centerY;
    _topImage.mj_y = whiteBack.mj_y - 10;
}

+(void)showWithModel:(CheckIfNeedUpdateModel *)model{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UpdateVersionView * view = [[UpdateVersionView alloc]init];
    view.model = model;
    [window addSubview:view];
}

-(void)updateBtnClick{
    [self openScheme:_model.downUrl];
}

- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

-(void)cancelBtnClick{
    [self removeSelf];
}

-(void)removeSelf
{
    if (_model.type == 1) {
        return;
    }else{
        [super removeSelf];
    }
}

@end

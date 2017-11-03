//
//  RecordTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/31.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "RecordTableViewCell.h"

@interface RecordTableViewCell (){
    CGFloat leftMargin ,rightMargin ,itemSpace;//左边间距、右边间距、lab间隔
    CGFloat singleW;//扣除所有空隙后，剩余的总宽度的十分之一
}


//一下label用于展示列表数据，从左至右（①~④），当只有三列时，隐藏fourthLab
@property (nonatomic,strong) UILabel * firstLab;//①
@property (nonatomic,strong) UILabel * secLab;//②
@property (nonatomic,strong) UILabel * thirdLab;//③
@property (nonatomic,strong) UILabel * fourthLab;//④

@end

@implementation RecordTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGFloat lab_H = 15;
        CGFloat lab_Y = 12;
        _firstLab = [self createLabWithFrame:CGRectMake( 0, lab_Y, 1, lab_H)];
        
        _secLab = [self createLabWithFrame:CGRectMake( 1, lab_Y, 1, lab_H)];
        
        _thirdLab = [self createLabWithFrame:CGRectMake( 2, lab_Y, 1, lab_H)];
        
        _fourthLab = [self createLabWithFrame:CGRectMake( 3, lab_Y, 1, lab_H)];

        _secLab.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
/**创建包含共同属性的lab*/
-(UILabel*)createLabWithFrame:(CGRect)frame{
    UILabel * lab = [[UILabel alloc]initWithFrame:frame];
    lab.font = kFont(12);
    lab.adjustsFontSizeToFitWidth  = YES;
    [self.contentView addSubview:lab];
    return lab;
}

-(void)setCellType:(RecordCellType)cellType
{
    _cellType = cellType;
    itemSpace = 10;
    _fourthLab.hidden = NO;
    UIColor * black = UIColorFromINTValue(110, 110, 110);//浅黑色
    UIColor * green = UIColorFromINTValue(68, 152, 47);//浅绿色
    UIColor * blue = UIColorFromINTValue(0, 149, 213);//浅蓝色
    UIColor * red = UIColorFromINTValue(192, 96, 98);//浅红色

    _firstLab.textColor = _secLab.textColor = _thirdLab.textColor = black;
    _fourthLab.textColor = green;
    _thirdLab.textAlignment = NSTextAlignmentRight;
    _fourthLab.textAlignment = NSTextAlignmentRight;
    _firstLab.textAlignment = NSTextAlignmentLeft;

    _firstLab.frame = CGRectMake( 0, 12, 1, 15);
    _firstLab.numberOfLines = 1;
    switch (cellType) {
        case RecordCellType_QuKuan:
        {
            leftMargin = 25;
            rightMargin = 30;
            singleW = (MAXWIDTH - leftMargin - rightMargin - itemSpace * 2) / 10;
            
            _firstLab.frame = CGRectMake( 0, 0, 1, 40);
            _firstLab.numberOfLines = 2;
            
            _firstLab.left = leftMargin;
            _firstLab.width = singleW * 5;
            
            _secLab.left = _firstLab.maxX + itemSpace;
            _secLab.width = singleW * 3;
            _secLab.textColor = _thirdLab.textColor = green;
            
            _thirdLab.left = _secLab.maxX + itemSpace;
            _thirdLab.width = singleW * 2;
            
            _fourthLab.hidden = YES;
        }
            break;

        case RecordCellType_CunKuan:
        case RecordCellType_ZhuanZhang:
        {
            leftMargin = 8;
            rightMargin = 30;
            singleW = (MAXWIDTH - leftMargin - rightMargin - itemSpace * 3) / 10;
            _firstLab.left = leftMargin;
            _firstLab.width = singleW * 3.6;
            
            _secLab.left = _firstLab.maxX + itemSpace;
            _secLab.width = singleW * 2.5;
            
            _thirdLab.left = _secLab.maxX + itemSpace;
            _thirdLab.width = singleW * 2.5;
            _thirdLab.textAlignment = NSTextAlignmentCenter;

            _fourthLab.left = _thirdLab.maxX + itemSpace;
            _fourthLab.width = singleW * 1.4;
        }
            break;
        case RecordCellType_YouHui:
        {
            leftMargin = 8;
            rightMargin = 30;
            singleW = (MAXWIDTH - leftMargin - rightMargin - itemSpace * 2) / 10;
            
            _firstLab.left = leftMargin;
            _firstLab.width = singleW * 5;
            _firstLab.textAlignment = NSTextAlignmentCenter;
            
            _secLab.left = _firstLab.maxX + itemSpace;
            _secLab.width = singleW * 3;
            
            _thirdLab.left = _secLab.maxX + itemSpace;
            _thirdLab.width = singleW * 2;
            _thirdLab.textColor = green;

            _fourthLab.hidden = YES;
        }
            break;
        default:
            break;
    }
}


-(void)setCell{
    _firstLab.text = @"20170818 14:36\n6212***********5443";
    _secLab.text =@"秒存支付宝";
    _thirdLab.text = @"15，00";
    _fourthLab.text = @"审核中";
}

-(void)setTopCellWithVCType:(RecordDetailControlType)detailVCType{
    self.accessoryType = UITableViewCellAccessoryNone;
    self.height = 28;
    _firstLab.textAlignment = NSTextAlignmentCenter;
    _secLab.textAlignment = NSTextAlignmentCenter;
    _thirdLab.textAlignment = NSTextAlignmentCenter;
    _fourthLab.textAlignment = NSTextAlignmentCenter;
    self.contentView.backgroundColor = UIColorFromINTValue(241, 241, 241);
    _firstLab.textColor = _secLab.textColor = _thirdLab.textColor = _fourthLab.textColor = UIColorFromINTValue(110, 110, 110);
    _firstLab.top = _secLab.top = _thirdLab.top = _fourthLab.top = 6;
   
    _firstLab.height = 15;
    _firstLab.numberOfLines = 1;
    
    switch (detailVCType) {
        case RecordDetailControlType_QuKuan:
        {
            _firstLab.text = @"取款时间/卡号";
            _secLab.text =@"金额";
            _thirdLab.text = @"状态";
        }
            break;
        case RecordDetailControlType_CunKuan:
        {
            _firstLab.text = @"存款时间";
            _secLab.text =@"类型";
            _thirdLab.text = @"金额";
            _fourthLab.text = @"状态";
        }
            break;
        case RecordDetailControlType_ZhuanZhang:
        {
            _firstLab.text = @"转账时间";
            _secLab.text =@"类型";
            _thirdLab.text = @"金额";
            _fourthLab.text = @"状态";
        }
            break;
        case RecordDetailControlType_YouHui:
        {
            _firstLab.text = @"优惠时间";
            _secLab.text =@"赠送金额";
            _thirdLab.text = @"状态";
        }
            break;
        case RecordDetailControlType_JiFenTop:
        {
            _firstLab.text = @"积分兑换时间";
            _secLab.text =@"兑换数量";
            _thirdLab.text = @"使用积分";
            _fourthLab.text = @"状态";
        }
            break;
        case RecordDetailControlType_JiFenBoom:
        {
            _firstLab.text = @"获取积分时间";
            _secLab.text =@"获取积分数量";
            _thirdLab.text = @"状态";
        }
            break;
        case RecordDetailControlType_TJLJ:
        {
            _firstLab.text = @"领取时间";
            _secLab.text =@"奖励数量";
            _thirdLab.text = @"朋友的账号";
            _fourthLab.text = @"状态";
        }
            break;
        default:{
            _firstLab.text = @"20170818 14:36";
            _secLab.text =@"秒存支付宝";
            _thirdLab.text = @"15，00";
            _fourthLab.text = @"审核中";
        }
            break;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

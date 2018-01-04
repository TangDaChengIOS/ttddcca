//
//  ShowRecordDetailView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/12/4.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ShowRecordDetailView.h"

@interface ShowRecordDetailView ()
@property (weak, nonatomic) IBOutlet UIView *whiteBack;
@property (weak, nonatomic) IBOutlet UILabel *topLab;

@property (weak, nonatomic) IBOutlet UILabel *sqNumLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLeftLab;

@property (weak, nonatomic) IBOutlet UILabel *cardNumLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLeftLab;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *notesLab;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation ShowRecordDetailView

- (IBAction)okBtnClick:(id)sender {
    [self removeFromSuperview];
}

-(void)setModel:(MoneyRecordModel *)model{
    _model = model;
    
    _cardNumLeftLab.text = @"卡号";
    _moneyLeftLab.text = @"金额";
    _statusImageView.image = nil;
    _whiteBack.layer.cornerRadius = 4.0f;
    _okBtn.layer.cornerRadius = 4.0f;
    switch (_recordType) {
        case RecordCellType_QuKuan:
        {
            _topLab.text = @"取款详情";
            _sqNumLab.text = model.seqNo;
            _timeLab.text = model.createdTime;
            _cardNumLab.text = model.cardNo;
            _moneyLab.text = model.amount;
            _statusLab.text = model.statusDesc;
            _notesLab.text = model.notes;
            if ([model.status isEqualToString:@"4"]) {
                _statusImageView.image =  KIMAGE(@"profile_detail_state_success_icon");
            }else if ([model.status isEqualToString:@"3"]){
                _statusImageView.image = KIMAGE(@"profile_detail_state_failure_icon");
            }
            
        }
            break;
            
        case RecordCellType_CunKuan:
        {
            _topLab.text = @"存款详情";

            _sqNumLab.text = model.seqNo;
            _timeLab.text = model.createdTime;
            _cardNumLeftLab.text = @"类型";
            _cardNumLab.text = model.type;
            _moneyLab.text = model.amount;
            _statusLab.text = model.statusDesc;
            _notesLab.text = model.notes;
            if ([model.status isEqualToString:@"1"]) {
                _statusImageView.image =  KIMAGE(@"profile_detail_state_success_icon");
            }else if ([model.status isEqualToString:@"0"]){
                _statusImageView.image = KIMAGE(@"profile_detail_state_failure_icon");
            }
        }
            break;
        case RecordCellType_ZhuanZhang:
        {
            _topLab.text = @"转账详情";

            _sqNumLab.text = model.seqNo;
            _timeLab.text = model.createdTime;
            _cardNumLeftLab.text = @"类型";
            _cardNumLab.text = model.type;
            _moneyLab.text = model.amount;
            _statusLab.text = model.statusDesc;
            _notesLab.text = model.notes;
            if ([model.status isEqualToString:@"1"]) {
                _statusImageView.image =  KIMAGE(@"profile_detail_state_success_icon");
            }else if ([model.status isEqualToString:@"2"]){
                _statusImageView.image = KIMAGE(@"profile_detail_state_failure_icon");
            }
        }
            break;
        case RecordCellType_YouHui:
        {
            _topLab.text = @"优惠详情";

            _sqNumLab.text = model.seqNo;
            _timeLab.text = model.createdTime;
            _cardNumLab.text = @"";
            _moneyLab.text = model.amount;
            _statusLab.text = model.statusDesc;
            _notesLab.text = model.notes;
            if ([model.status isEqualToString:@"1"]) {
                _statusImageView.image =  KIMAGE(@"profile_detail_state_success_icon");
            }else if ([model.status isEqualToString:@"2"]){
                _statusImageView.image = KIMAGE(@"profile_detail_state_failure_icon");
            }
        }
            break;
        case RecordCellType_TJLJ:
        {
            _topLab.text = @"礼金详情";

            _sqNumLab.text = model.seqNo;
            _timeLab.text = model.createdTime;
            _cardNumLeftLab.text = @"账号";
            _cardNumLab.text = model.account;
            _moneyLab.text = model.num;//数量
            _statusLab.text = model.statusDesc;
            _notesLab.text = @"";
            
            if ([model.status isEqualToString:@"1"]) {
                _statusImageView.image =  KIMAGE(@"profile_detail_state_success_icon");
            }else{
                _statusImageView.image = KIMAGE(@"profile_detail_state_failure_icon");
            }

        }
            break;
        case RecordCellType_JiFenTop:
        {
            _topLab.text = @"积分兑换详情";

            _sqNumLab.text = model.seqNo;
            _timeLab.text = model.createdTime;
            _cardNumLeftLab.text = @"积分";
            _cardNumLab.text = model.point;
            _moneyLab.text = model.amount;//数量
            _statusLab.text = model.statusDesc;
            _notesLab.text = @"";
            if ([model.status isEqualToString:@"1"]) {
                _statusImageView.image =  KIMAGE(@"profile_detail_state_success_icon");
            }else{
                _statusImageView.image = KIMAGE(@"profile_detail_state_failure_icon");
            }
        }
            break;
        case RecordCellType_JiFenBoom:
        {
            _topLab.text = @"积分获取详情";

            _sqNumLab.text = model.seqNo;
            _timeLab.text = model.createdTime;
            _cardNumLab.text = @"";
            _moneyLeftLab.text = @"数量";
            _moneyLab.text = model.points;//数量
            _statusLab.text = model.statusDesc;
            _notesLab.text = @"";
            if ([model.status isEqualToString:@"1"]) {
                _statusImageView.image =  KIMAGE(@"profile_detail_state_success_icon");
            }else{
                _statusImageView.image = KIMAGE(@"profile_detail_state_failure_icon");
            }
        }
            break;
        default:
            break;
    }
}
//-(UIImage *)getImageWithString:(NSString *)string{
//    if ([string containsString:@"成功"]) {
//        return KIMAGE(@"profile_detail_state_success_icon");
//    }
//    else if ([string containsString:@"失败"]){
//        return KIMAGE(@"profile_detail_state_failure_icon");
//    }
//    return nil;
//}

+(void)showWithModel:(MoneyRecordModel *)model andRecordType:(RecordCellType)recordType
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    ShowRecordDetailView * view = [[NSBundle mainBundle]loadNibNamed:@"ShowRecordDetailView" owner:self options:nil][0];
    view.frame = CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT);
    view.recordType = recordType;
    view.model = model;
    [window addSubview:view];
}


@end

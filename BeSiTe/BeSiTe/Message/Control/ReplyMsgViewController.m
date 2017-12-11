//
//  ReplyMsgViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ReplyMsgViewController.h"

@interface ReplyMsgViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *replyTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLab;
@property (weak, nonatomic) IBOutlet UITextView *msgsTextView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic,strong) UserMsgReplyModel* replyModel;


@end

@implementation ReplyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    self.title = @"回复消息";
    _msgsTextView.editable = NO;
    _textView.delegate = self;
    [self requestData];
}


-(void)requestData{
    kWeakSelf
    [MBProgressHUD showMessage:@"数据加载中..." toView:nil];
    [RequestManager postManagerDataWithPath:@"user/msgReplys" params:@{@"msgId":self.model.msgId } success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];

        NSLog(@"%@",JSON);
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        UserMsgReplyModel * model = [UserMsgReplyModel new];
        [model mj_setKeyValues:JSON];
        weak_self.replyModel = model;
        [weak_self dealHistoryMsg];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];

    }];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"说点什么..."] && textView == self.textView) {
        textView.text = @"";
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0 && textView == self.textView) {
        textView.text = @"说点什么...";
    }
}


-(void)readData{
    self.replyTitleLab.text = _model.title;
    self.replyTimeLab.text = _model.time;
}

-(void)dealHistoryMsg
{
    NSMutableAttributedString * mString = [[NSMutableAttributedString alloc]init];
    if ([self.replyModel.userId isEqualToString:@"0"]) {
        [mString appendAttributedString:[self getSystemAttributeString]];
    }else{
        [mString appendAttributedString:[self getMineAttributeString]];
    }
    [mString appendAttributedString:[self getCommonAttributeString:[NSString stringWithFormat:@"  %@\n\n",self.replyModel.content]]];

    
    for (ReplyModel * model in self.replyModel.reply) {
        if ([model.userId isEqualToString:@"0"]) {
            [mString appendAttributedString:[self getSystemAttributeString]];
        }else{
            [mString appendAttributedString:[self getMineAttributeString]];
        }
        [mString appendAttributedString:[self getCommonAttributeString:[NSString stringWithFormat:@"  %@\n\n",model.content]]];
    }

    _msgsTextView.attributedText = mString;
    [_msgsTextView scrollRangeToVisible:NSMakeRange(mString.length - 1, 1)];
}

-(NSAttributedString *)getCommonAttributeString:(NSString *)string{
    NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:string attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999),NSFontAttributeName:kFont(12)}];
    return attStr;
}


-(NSAttributedString *)getMineAttributeString{
    NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:@" 我" attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666),NSFontAttributeName:kFont(12),NSBackgroundColorAttributeName:UIColorFromINTValue(172, 229, 236),NSKernAttributeName:@(5)}];
    return attStr;
}

-(NSAttributedString *)getSystemAttributeString{
    NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:@"系统" attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666),NSFontAttributeName:kFont(12),NSBackgroundColorAttributeName:UIColorFromINTValue(216, 216, 216),NSKernAttributeName:@(1.2)}];
    return attStr;
}


- (IBAction)sengBtnClick:(id)sender {

    if (self.textView.text.length <= 0 || [self.textView.text isEqualToString:@"说点什么..."]) {
        TTAlert(@"请输入您想说的内容");
        return;
    }
    NSDictionary * dict = @{@"userId":[BSTSingle defaultSingle].user.userId,
                            @"content":self.textView.text,
                            @"msgId":self.model.msgId};
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postManagerDataWithPath:@"user/msg" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [weak_self requestData];
        weak_self.textView.text = @"";
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"发送成功";
        view.msgDetail = @"我们将在24小时内给您及时回复，请耐心的等待...";
        [view showInWindow];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil];
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

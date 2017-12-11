//
//  SendNewMsgViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "SendNewMsgViewController.h"
#import "EmailTypeViewController.h"

@interface SendNewMsgViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation SendNewMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发送新消息";
    _msgTextView.delegate = self;
//    _msgTextView.layer.borderColor = UIColorFromRGBValue(0xffffff).CGColor;
//    _msgTextView.layer.borderWidth = 1.0f;

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"说点什么..."]) {
        textView.text = @"";
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        textView.text = @"说点什么...";
    }
}

- (IBAction)selectTypeBtnClick:(id)sender {
    EmailTypeViewController * typeVC = [[EmailTypeViewController alloc]init];
    kWeakSelf
    typeVC.finishBlock = ^(NSString * type){
        weak_self.typeLab.text = type;
    };
    [self pushVC:typeVC];
}
- (IBAction)sendBtnClick:(id)sender
{
    if (self.typeLab.text.length <= 0 ) {
        TTAlert(@"请选择邮件主题类型");
        return;
    }
    if (self.msgTextView.text.length <= 0 || [self.msgTextView.text isEqualToString:@"说点什么..."]) {
        TTAlert(@"请输入您想说的内容");
        return;
    }
    NSDictionary * dict = @{@"userId":[BSTSingle defaultSingle].user.userId,
                            @"title":self.typeLab.text,
                            @"content":self.msgTextView.text};
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postManagerDataWithPath:@"user/msg" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        weak_self.msgTextView.text = @"";
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

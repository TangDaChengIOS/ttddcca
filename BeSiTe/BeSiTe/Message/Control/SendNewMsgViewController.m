//
//  SendNewMsgViewController.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "SendNewMsgViewController.h"
#import "EmailTypeViewController.h"
#import "BSTSendMessageView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface SendNewMsgViewController ()
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (nonatomic,strong) BSTSendMessageView * messageView;
@end

@implementation SendNewMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发送新消息";
    
    _messageView = [[BSTSendMessageView alloc]initWithFrame:CGRectMake(0, MAXHEIGHT - 64 - 50 , MAXWIDTH, 50)];
    [_messageView.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_messageView];
    
    self.typeLab.text = _emailTypeString;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self.messageView.textView becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}


- (IBAction)selectTypeBtnClick:(id)sender {
    EmailTypeViewController * typeVC = [[EmailTypeViewController alloc]init];
    kWeakSelf
    typeVC.finishBlock = ^(NSString * type){
        weak_self.typeLab.text = type;
    };
    [self pushVC:typeVC];
}
- (void)sendBtnClick:(id)sender
{
    [self.view endEditing:YES];
    if (self.typeLab.text.length <= 0 ) {
        TTAlert(@"请选择邮件主题类型");
        return;
    }
    if (self.messageView.textView.text.length <= 0 || [self.messageView.textView.text isEqualToString:@"说点什么..."]) {
        TTAlert(@"请输入您想说的内容");
        [self.messageView.textView becomeFirstResponder];
        return;
    }
    NSDictionary * dict = @{@"userId":[BSTSingle defaultSingle].user.userId,
                            @"title":self.typeLab.text,
                            @"content":self.messageView.textView.text};
    kWeakSelf
    [MBProgressHUD showMessage:@"" toView:nil];
    [RequestManager postManagerDataWithPath:@"user/msg" params:dict success:^(id JSON ,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:nil];
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        [weak_self.messageView setDefaultUI];
        BSTMessageView * view = [[[NSBundle mainBundle]loadNibNamed:@"BSTMessageView" owner:self options:nil] firstObject];
        view.showType = ShowTypeWaitThreeSec;
        view.isSuccessMsg = YES;
        view.isNotAllowRemoveSelfByTouchSpace = YES;
        view.msgTitle = @"发送成功";
        view.msgDetail = @"我们将在24小时内给您及时回复，请耐心的等待...";
        [view showInWindow];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIViewController * vc in self.navigationController.viewControllers) {
                if ([NSStringFromClass([vc class]) isEqualToString:@"MessageViewController"]) {
                    [weak_self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        });
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

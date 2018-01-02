//
//  ActivityTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCell ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;//webView 与开始游戏按钮的父视图的高度约束

@property (nonatomic,strong) ActivityModel * model;
@end
@implementation ActivityTableViewCell


-(void)setCellWithModel:(ActivityModel *)model isOpenState:(BOOL)isOpen
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.model = model;
    if (!isOpen) {
        _webViewHeightConstraint.constant = 0;
        _rightImageView.image =KIMAGE(@"common_next_icon");
        _webView.hidden = YES;
        _playBtn.hidden = YES;
    }else{
        _webView.hidden = NO;
        if (model.type == 2) {
            _webViewTopConstraint.constant = 45;
            _playBtn.hidden = NO;
        }else{
            _webViewTopConstraint.constant = 10;
            _playBtn.hidden = YES;
        }
        _webView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
        _webViewHeightConstraint.constant = 260;
        _rightImageView.image =KIMAGE(@"common_open_icon");
        [_webView loadHTMLString:model.content baseURL:nil];
        _webView.delegate = self;
    }
    [_leftImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:KIMAGE(@"commmon_home_history")];
    _titleLab.text = model.title;
    _detailLab.text = model.gameCode;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"function imgAutoFit() { \
                        var imgs = document.getElementsByTagName('img'); \
                        for (var i = 0; i < imgs.length; ++i) {\
                            var img = imgs[i];   \
                            img.style.maxWidth = %f;   \
                        } \
                    }";
                //img.style.maxHeight = %f;    \

    js = [NSString stringWithFormat:js, MAXWIDTH - 20];  // 设置宽高，高度可以不设置

    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];

    //页面背景色
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f6f6f6'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.background='#f6f6f6'"];
    
}
//作者：何年何月
//链接：http://www.jianshu.com/p/5aa7383fe39f
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。


- (IBAction)playBtnClick:(id)sender {
    if (self.beginPlayGameBlock && self.model.game) {
        self.beginPlayGameBlock(self.model.game);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorFromINTValue(230, 230, 230);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

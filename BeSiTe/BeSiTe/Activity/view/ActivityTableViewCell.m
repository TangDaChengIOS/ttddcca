//
//  ActivityTableViewCell.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@end
@implementation ActivityTableViewCell


-(void)setIsOpenState:(BOOL)isOpen
{
    if (!isOpen) {
        _webViewHeightConstraint.constant = 0.1;
        _rightImageView.image =KIMAGE(@"common_next_icon");
        _webView.hidden = YES;
    }else{
        _webView.hidden = NO;
        _webViewHeightConstraint.constant = 260;
        _rightImageView.image =KIMAGE(@"common_open_icon");
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

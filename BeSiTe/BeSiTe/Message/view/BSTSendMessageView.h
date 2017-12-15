//
//  BSTSendMessageView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/12/14.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTSendMessageView : UIView

@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UIButton * sendBtn;

-(void)setDefaultUI;
-(void)removeObserver;
@end

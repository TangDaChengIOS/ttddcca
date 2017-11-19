//
//  RecordSelectToolView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**交易记录，搜索条件*/
@interface RecordSelectToolView : UIView

@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * dateLab;
@property (nonatomic,strong) UIImageView * leftImageView;

@property (nonatomic,assign) BOOL isOpen;//是否展开状态
@property (nonatomic,assign) BOOL isCanOpen;//是否可以展开

@property (nonatomic,copy) void (^eventBlock)(BOOL);

@end

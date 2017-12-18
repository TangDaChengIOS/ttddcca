//
//  ATTranslucentView.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/30.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATTranslucentView : UIView{
    UIView * whiteBack;
}

@property (nonatomic,assign) BOOL  isNeedObserveKeyBoard;

-(void)removeSelf;

-(UITextField *)createTextFieldWithFrame:(CGRect)frame;

@end

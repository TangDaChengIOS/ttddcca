//
//  UIView+ATADD.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/21.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ATADD)

/**boom坐标*/
@property (nonatomic,readonly) CGFloat maxY;

/**right坐标*/
@property (nonatomic,readonly) CGFloat maxX;

/**Y轴偏移，并且Height相应变化*/
@property (nonatomic) CGFloat y_offset;

@end

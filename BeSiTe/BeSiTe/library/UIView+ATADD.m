//
//  UIView+ATADD.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/21.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "UIView+ATADD.h"

@implementation UIView (ATADD)

-(CGFloat)maxX
{
    return self.frame.origin.x + self.frame.size.width;
}
-(CGFloat)maxY
{
    return self.frame.origin.y + self.frame.size.height;
}


@end

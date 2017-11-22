//
//  GamesModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/2.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GamesModel.h"

@implementation GamesModel


-(UIImage *)getTypeImage{
    if (_isHot) {
        return  KIMAGE(@"home_activity_hot_icon");
    }
    else{
        if (_isNew) {
            return  KIMAGE(@"home_game_platform_new_icon");
        }
        else{
            return  nil;
        }
    }
}
-(NSString *)tryUrl
{
    return @"http://lobby.sgplayfun.com/touch/spadenew/?game=S-HY01&language=en_US&menumode=on&token=876f6d102760ad11c7ba6e4ce990506f3ea9635bcecfa33be0e43bd6419198bfee6924f5ffafd09d26c18acc06fb9b4abb49542ca0aa9a225b79e4dc4b76e3b7";
}
-(NSString *)gameUrl{
    return @"http://lobby.sgplayfun.com/touch/spadenew/?game=S-HY01&language=en_US&menumode=on&token=876f6d102760ad11c7ba6e4ce990506f3ea9635bcecfa33be0e43bd6419198bfee6924f5ffafd09d26c18acc06fb9b4abb49542ca0aa9a225b79e4dc4b76e3b7";
}

@end

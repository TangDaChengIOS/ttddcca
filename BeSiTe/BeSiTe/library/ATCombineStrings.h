//
//  ATCombineStrings.h
//  BeSiTe
//
//  Created by 汤达成 on 17/11/10.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCombineStrings : NSObject

+(NSAttributedString *)combineStrings:(NSArray<NSString *>*)strings withAttributes:(NSArray <NSDictionary *>*)attributes;
@end

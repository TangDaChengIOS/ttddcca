//
//  ContactModel.m
//  BeSiTe
//
//  Created by 汤达成 on 17/11/9.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([[value class]isSubclassOfClass:[NSDictionary class]]) {
        ContactDetailModel * model = [ContactDetailModel new];
        [model setValuesForKeysWithDictionary:value];
        [super setValue:model forKey:key];
    }
    else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation ContactDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        [super setValue:value forUndefinedKey:@"descri"];
    }
}

@end

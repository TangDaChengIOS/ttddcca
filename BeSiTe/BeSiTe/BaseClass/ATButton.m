//
//  ATButton.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/27.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "ATButton.h"

@implementation ATButton

-(instancetype)init{
    if (self = [super init]) {
        _fullImageView = [[UIImageView alloc]init];
        [self addSubview:_fullImageView];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:@""];
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:@""];

        
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    ATButton * button = (ATButton *)object;
    if (button == self && [keyPath isEqualToString:@"frame"]) {
        self.fullImageView.frame = self.bounds;
    }
    else if (button == self && [keyPath isEqualToString:@"selected"]){
        NSLog(@"2");
        self.fullImageView.image = self.isSelected ? KIMAGE(self.selectImage) : KIMAGE(self.normalImage);
    }
}


-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
    [self removeObserver:self forKeyPath:@"selected"];
}
@end

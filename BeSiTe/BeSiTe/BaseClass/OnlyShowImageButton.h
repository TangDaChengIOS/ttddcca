//
//  ATButton.h
//  BeSiTe
//
//  Created by 汤达成 on 17/10/27.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**仅显示图片的按钮*/
@interface OnlyShowImageButton : UIButton

@property (nonatomic,copy) NSString * normalImage;
@property (nonatomic,copy) NSString * selectImage;
@property (nonatomic,strong) UIImageView * fullImageView;
@end

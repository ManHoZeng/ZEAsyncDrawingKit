//
//  ZEButton.h
//  demo
//
//  Created by Apple on 2017/10/29.
//  Copyright © 2017年 Apple. All rights reserved.
//


#import "ZEControl.h"

/**
 *  图标在上，文本在下按钮的图文间隔比例（0-1），默认0.8
 */
#define ZE_buttonTopRadio 0.8
/**
 *  图标在下，文本在上按钮的图文间隔比例（0-1），默认0.5
 */
#define ZE_buttonBottomRadio 0.5

typedef enum{
    // 正常
    ZEButtonAlignmentStatusNormal,
    // 图标和文本位置变化
    ZEButtonAlignmentStatusLeft,// 左对齐
    ZEButtonAlignmentStatusCenter,// 居中对齐
    ZEButtonAlignmentStatusRight,// 右对齐
    ZEButtonAlignmentStatusTop,// 图标在上，文本在下(居中)
    ZEButtonAlignmentStatusBottom, // 图标在下，文本在上(居中)
}ZEButtonAlignmentStatus;
@interface ZEButton : ZEControl



@property(nonatomic,copy) void(^DisplayFinish)();




@property (nonatomic,assign)ZEButtonAlignmentStatus alignmentStatus;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets forState:(UIControlState)state;
- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets forState:(UIControlState)state;

@end

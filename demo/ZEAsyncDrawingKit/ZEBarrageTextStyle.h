//
//  ZEBarrageTextStyle.h
//  demo
//
//  Created by Apple on 2018/1/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ZEBarrageTextStyle : NSObject

@property (nonatomic, strong, nullable) UIFont *textFont;
@property (nonatomic, strong, nullable) UIColor *textColor;

/*
 * 关闭文字阴影可大幅提升性能, 推荐使用strokeColor, 与shadowColor相比strokeColor性能更强悍
 */
@property (nonatomic, assign) BOOL textShadowOpened;//默认NO
@property (nonatomic, strong, nullable) UIColor *shadowColor;//默认黑色
@property (nonatomic, assign) CGSize shadowOffset;//默认CGSizeZero
@property (nonatomic, assign) CGFloat shadowRadius;//默认2.0
@property (nonatomic, assign) CGFloat shadowOpacity;//默认0.5

@property (nonatomic, strong, nullable) UIColor *strokeColor;
@property (nonatomic, assign) int strokeWidth;//笔画宽度(粗细)，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果

@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;



@end

//
//  ZEControl.h
//  demo
//
//  Created by Apple on 2017/10/31.
//  Copyright © 2017年 Apple. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZEAsyncLayer.h"

@interface ZEControl : UIView

@property (nonatomic) BOOL displaysAsynchronously;//default:NO

/**
 默认是 YES，如果是 NO，那么会忽略所有的点击事件
 */
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

/**
 默认是 NO，表示是是否被选择中
 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/**
 默认是 NO，如果是 YES，则表示当前 View 处于高亮状态
 */
@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;

/**
 表示是否正在响应触摸事件
 */
@property (nonatomic, assign, readonly, getter=isTracking) BOOL tracking;

/**
 表示手指是否触摸在当前 View 上
 */
@property (nonatomic, assign, readonly, getter=isTouchInside) BOOL touchInside;

/**
 could be more than one state (e.g. disabled|selected). synthesized from other flags.
 */
@property (nonatomic, assign, readonly) UIControlState state;

- (NSString *)stringOfState:(UIControlState)state;

- (void)_setLayoutNeedRedraw;

- (void)_clearContents;

/**
 添加触摸事件
 
 @param target a target
 @param action an action
 @param controlEvents 需要响应哪一种事件
 */
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 移除触摸事件
 
 @param target a target
 @param action an action
 @param controlEvents 需要移除哪一种事件
 */
- (void)removeTarget:(id)target action:(SEL)action fotControlEvents:(UIControlEvents)controlEvents;


@end

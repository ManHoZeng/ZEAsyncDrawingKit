//
//  ZENormalBarrage.h
//  demo
//
//  Created by Apple on 2018/1/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEBarrageTextStyle.h"
@interface ZENormalBarrage : UIView

@property (nonatomic,strong)ZEBarrageTextStyle * model;

- (void)setTextStyle:(void(^)(ZEBarrageTextStyle * model))block;

- (void)renderBarrageInView:(UIView *)view;

@end

//
//  ZEBarrageManger.m
//  demo
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZEBarrageManger.h"

@interface ZEBarrageManger()<CAAnimationDelegate>

@property (nonatomic,strong)NSMutableArray * freeCells;

@end

@implementation ZEBarrageManger

- (nullable ZENormalBarrage *)dequeueReusableCellWithClass{
    
   __block ZENormalBarrage * cell = nil;
    
    [self.freeCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[cell class]]) {
            cell = obj;
            *stop = YES;
        }
    }];
    
    if (cell) {
        
        [self.freeCells removeObject:cell];
        
    }
    else{
        
        cell = [ZENormalBarrage new];
        
    }
    
    return cell;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
}

@end

//
//  ZENormalBarrage.m
//  demo
//
//  Created by Apple on 2018/1/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZENormalBarrage.h"
#import "ZEAsyncLayer.h"

static dispatch_queue_t ZEGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

@interface ZENormalBarrage()<CAAnimationDelegate>



@end

@implementation ZENormalBarrage

-(void)dealloc{
    
    NSLog(@"%s", __func__);
    
}

- (void)z_clearContents{
    CGImageRef image = (__bridge_retained CGImageRef)(self.layer.contents);
    self.layer.contents = nil;
    if (image) {
        dispatch_async(ZEGetReleaseQueue(), ^{
            CFRelease(image);
        });
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        ((ZEAsyncLayer *)self.layer).displaysAsynchronously = YES;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.contentMode = UIViewContentModeRedraw;
        self.frame = frame;

    }
    return self;
}


+ (Class)layerClass {
    return [ZEAsyncLayer class];
}

- (void)z_setLayoutNeedRedraw{
    [self.layer setNeedsDisplay];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
//    NSLog(@"停止了");
    [self z_clearContents];
    NSEnumerator *layerEnumerator = [self.layer.sublayers reverseObjectEnumerator];
    CALayer *sublayer = nil;
    while (sublayer = [layerEnumerator nextObject]){
        [sublayer removeFromSuperlayer];
    }
    
//    anim.delegate = nil;
    [self.layer removeAnimationForKey:@"kBarrageAnimation"];
    [self removeFromSuperview];
}


- (void)setTextStyle:(void(^)(ZEBarrageTextStyle * model))block{
    
    ZEBarrageTextStyle * model  = [ZEBarrageTextStyle new];
    block(model);
    _model = model;
    NSLog(@"%@",_model.text);
    NSDictionary *attribute = @{NSFontAttributeName: model.textFont};
    CGRect textFrame = [_model.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    self.frame = textFrame;
}

-(void)renderBarrageInView:(UIView *)view{
    
    [view addSubview:self];
    [self z_clearContents];
    [self z_setLayoutNeedRedraw];
}


#pragma mark - 绘制按钮
- (ZEAsyncLayerDisplayTask *)newAsyncDisplayTask{
    
    __weak __typeof(&*self)weakSelf = self;
    
    
    ZEAsyncLayerDisplayTask *task = [ZEAsyncLayerDisplayTask new];
    
    task.willDisplay = ^(CALayer *layer){
        
    };
    
    
    
    task.display = ^(CGContextRef context,CGSize size,BOOL (^isCancelled)(void)){
        if ( isCancelled() ) {
            return ;
        }
        CGContextSaveGState(context);
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        
        if (isCancelled()) {
            CGContextRestoreGState(context);
            return;
        }
        
        if (weakSelf.model.text) {
            NSDictionary *attribute = @{NSFontAttributeName: weakSelf.model.textFont};
             [weakSelf.model.text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attribute];
            
        }
        
    };
    
    
    task.didDisplay = ^(CALayer *layer,BOOL finished){
        if (!finished) {
            return ;
        }
        
        CGFloat top = arc4random_uniform([UIScreen mainScreen].bounds.size.height) * 2 + 70;
        
        if (top >= [UIScreen mainScreen].bounds.size.height) {
            
            top = arc4random_uniform([UIScreen mainScreen].bounds.size.height) -  layer.frame.size.height - 20;
            
        }
        
        weakSelf.frame = CGRectMake(0, top, layer.frame.size.width, layer.frame.size.height);
        
        CGPoint startCenter = CGPointMake(CGRectGetMaxX(self.superview.bounds) + CGRectGetWidth(self.bounds)/2, self.center.y);
        CGPoint endCenter = CGPointMake(-(CGRectGetWidth(self.bounds)/2), self.center.y);

        CAKeyframeAnimation *walkAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        walkAnimation.values = @[[NSValue valueWithCGPoint:startCenter], [NSValue valueWithCGPoint:endCenter]];
        walkAnimation.keyTimes = @[@(0.0), @(1.0)];
        walkAnimation.duration = arc4random()%5 + 5;
        walkAnimation.repeatCount = 1;
        walkAnimation.delegate =  weakSelf;
        walkAnimation.removedOnCompletion = NO;
        walkAnimation.fillMode = kCAFillModeForwards;

        [self.layer addAnimation:walkAnimation forKey:@"kBarrageAnimation"];
    };
    
    return task;
    
}

@end

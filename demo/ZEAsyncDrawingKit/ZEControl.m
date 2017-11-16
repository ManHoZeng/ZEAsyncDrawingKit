//
//  ZEControl.m
//  demo
//
//  Created by Apple on 2017/10/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ZEControl.h"

@interface ZEControlTargetAction : NSObject
@property (nonatomic, assign) SEL action;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) UIControlEvents controlEvents;
@end

@implementation ZEControlTargetAction
@end

static dispatch_queue_t ZEGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

@interface ZEControl()<ZEAsyncLayerDelegate>
{
    NSMutableArray<ZEControlTargetAction *> *_targetActions;
}
@end

@implementation ZEControl

+ (Class)layerClass {
    return [ZEAsyncLayer class];
}

- (void)setEnabled:(BOOL)enabled
{
    if (_enabled != enabled) {
        _enabled = enabled;
        self.userInteractionEnabled = enabled;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        
        if (_displaysAsynchronously) {
            [self _clearContents];
        }
        [self _setLayoutNeedRedraw];
        
    }
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        
        if (_displaysAsynchronously) {
            [self _clearContents];
        }
        [self _setLayoutNeedRedraw];
    }
}

- (void)setDisplaysAsynchronously:(BOOL)displaysAsynchronously {
    _displaysAsynchronously = displaysAsynchronously;
    ((ZEAsyncLayer *)self.layer).displaysAsynchronously = displaysAsynchronously;
}

- (void)_clearContents{
    CGImageRef image = (__bridge_retained CGImageRef)(self.layer.contents);
    self.layer.contents = nil;
    if (image) {
        dispatch_async(ZEGetReleaseQueue(), ^{
            CFRelease(image);
        });
    }
}

- (void)_setLayoutNeedRedraw{
    [self.layer setNeedsDisplay];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (action) {
        ZEControlTargetAction *targetAction = [[ZEControlTargetAction alloc] init];
        targetAction.target = target;
        targetAction.action = action;
        targetAction.controlEvents = controlEvents;
        [self.targetActions addObject:targetAction];
    }
}

- (void)removeTarget:(id)target action:(SEL)action fotControlEvents:(UIControlEvents)controlEvents
{
    NSMutableArray<ZEControlTargetAction *> *removeTargetAcitons = @[].mutableCopy;
    for (ZEControlTargetAction *targetAction in self.targetActions) {
        if (target == targetAction.target && action == targetAction.action && controlEvents == targetAction.controlEvents) {
            [removeTargetAcitons addObject:targetAction];
        }
    }
    [self.targetActions removeObjectsInArray:removeTargetAcitons];
}

- (NSArray<NSString *> *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent
{
    NSMutableArray<NSString *> *actions = @[].mutableCopy;
    for (ZEControlTargetAction *targetAction in self.targetActions) {
        if (target == targetAction.target && controlEvent == targetAction.controlEvents) {
            [actions addObject:NSStringFromSelector(targetAction.action)];
        }
    }
    return actions;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _touchInside = YES;
    UITouch *touch = [touches anyObject];
    _tracking = YES;
    self.highlighted = YES;
    if (self.isTracking) {
        
        UIControlEvents controlEvents = UIControlEventTouchDown;
        if ([touch tapCount] > 1) {
            controlEvents = UIControlEventTouchDown | UIControlEventTouchDownRepeat;
        }
        
        [self _sendActionsForControlEvents:controlEvents withEvent:event];
        
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point;
    if (touch) {
        point = [touch locationInView:self];
    } else {
        point = CGPointZero;
    }
    BOOL touchInside = [self pointInside:point withEvent:event];
    _touchInside = touchInside;
    self.highlighted = touchInside;
    if (_tracking) {
        BOOL continueTracking = YES;
        _tracking = continueTracking;
        if (continueTracking) {
            UIControlEvents controlEvents = UIControlEventTouchDragOutside;
            if (self.touchInside) {
                controlEvents = UIControlEventTouchDragInside;
            }
            if (!touchInside && self.touchInside) {
                controlEvents = controlEvents | UIControlEventTouchDragEnter;
            } else if (touchInside && !self.touchInside) {
                controlEvents = controlEvents | UIControlEventTouchDragExit;
            }
            [self _sendActionsForControlEvents:controlEvents withEvent:event];
        }
    } else {
        if (!touchInside) {
            [self _sendActionsForControlEvents:UIControlEventTouchDragOutside withEvent:event];
        } else {
            [self _sendActionsForControlEvents:UIControlEventTouchDragInside withEvent:event];
            _tracking = YES;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point;
    if (touch) {
        point = [touch locationInView:self];
    } else {
        point = CGPointZero;
    }
    _touchInside = [self pointInside:point withEvent:event];
    self.highlighted = NO;
    if (_tracking) {
        //        [self endTrackingWithTouch:touch withEvent:event];
        UIControlEvents controlEvents = UIControlEventTouchUpOutside;
        if (self.touchInside) {
            controlEvents = UIControlEventTouchUpInside;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _sendActionsForControlEvents:controlEvents withEvent:event];
        });
    }
    _touchInside = NO;
    _tracking = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    if (self.tracking) {
        //        [self cancelTrackingWithEvent:event];
        [self _sendActionsForControlEvents:UIControlEventTouchCancel withEvent:event];
    }
    _tracking = NO;
    _touchInside = NO;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:action to:target from:self forEvent:event];
}

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event
{
    [self.targetActions enumerateObjectsUsingBlock:^(ZEControlTargetAction * _Nonnull targetAction, NSUInteger idx, BOOL * _Nonnull stop) {
        if (targetAction.target && controlEvents & targetAction.controlEvents) {
            [self sendAction:targetAction.action to:targetAction.target forEvent:event];
        }
    }];
}


- (NSMutableArray<ZEControlTargetAction *> *)targetActions
{
    if (!_targetActions) {
        _targetActions = @[].mutableCopy;
    }
    return _targetActions;
}

- (UIControlState)state
{
    UIControlState _state = UIControlStateNormal;
    if (self.isHighlighted) {
        _state = UIControlStateHighlighted;
    }
    if (!self.isEnabled) {
        _state = _state | UIControlStateDisabled;
    }
    if (self.isSelected) {
        _state = _state | UIControlStateSelected;
    }
    return _state;
}
- (NSString *)stringOfState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            return @"UIControlStateNormal";
        case UIControlStateHighlighted:
            return @"UIControlStateHighlighted";
        case UIControlStateDisabled:
            return @"UIControlStateDisabled";
        case UIControlStateSelected:
            return @"UIControlStateSelected";
        case UIControlStateFocused:
            return @"UIControlStateFocused";
        case UIControlStateApplication:
            return @"UIControlStateApplication";
        case UIControlStateReserved:
            return @"UIControlStateReserved";
    }
    
    return @"UIControlStateNormal";
}


- (ZEAsyncLayerDisplayTask *)newAsyncDisplayTask{
    
    ZEAsyncLayerDisplayTask *task = [ZEAsyncLayerDisplayTask new];
    
    task.willDisplay = ^(CALayer *layer){
        
    };
    
    
    
    task.display = ^(CGContextRef context,CGSize size,BOOL (^isCancelled)(void)){
        if ( isCancelled() ) {
            return ;
        }
    };
    
    
    task.didDisplay = ^(CALayer *layer,BOOL finished){
        if (!finished) {
            return ;
        }
        
        
    };
    
    return task;
    
}

@end

//
//  ZEAsyncLayer.h
//  demo
//
//  Created by Apple on 2017/10/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class ZEAsyncLayerDisplayTask;



NS_ASSUME_NONNULL_BEGIN

@interface ZEAsyncLayer : CALayer

@property BOOL displaysAsynchronously;

//@property (nonatomic,weak)id <ZEAsyncLayerDelegate> delegate;

@end

@protocol ZEAsyncLayerDelegate <NSObject>
@required

- (ZEAsyncLayerDisplayTask *)newAsyncDisplayTask;

@end




@interface ZEAsyncLayerDisplayTask : NSObject

@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));

@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);

@end

NS_ASSUME_NONNULL_END

//
//  ZEButton.m
//  demo
//
//  Created by Apple on 2017/10/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ZEButton.h"
#import "ZEAsyncLayer.h"



@interface ZEButtonInfo : NSObject
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

@end

@implementation ZEButtonInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.title = @"";
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
        
    }
    return self;
}

@end


@interface ZEButton ()<ZEAsyncLayerDelegate>
{
    NSMutableDictionary<NSString *, ZEButtonInfo *> *_buttonInfos;
    NSMutableDictionary<NSString *, UIImage *> *_images;
    NSMutableDictionary<NSString *, UIColor *> *_titleColors;
    NSMutableDictionary<NSString *, NSString *> *_titles;
    
    
    CGRect _backgroundFrame;
    CGRect _imageFrame;
    CGRect _titleFrame;
    
    NSString *_renderedTitle;
    UIImage *_renderedImage;
    UIImage *_renderedBackgroundImage;
    CGSize _renderedBoundsSize;
    
    
}
@end

@implementation ZEButton



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        ((ZEAsyncLayer *)self.layer).displaysAsynchronously = YES;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.contentMode = UIViewContentModeRedraw;
        self.frame = frame;
        
        [self configure];
    }
    return self;
}

#pragma mark - 配置
- (void)configure
{
//    _titleFont = [UIFont systemFontOfSize:15];
    _titles = @{}.mutableCopy;
    _titleColors = @{}.mutableCopy;
    _images = @{}.mutableCopy;
    _buttonInfos = @{}.mutableCopy;
    
    self.clearsContextBeforeDrawing = NO;
    self.enabled = YES;
    
    
    
    NSString * state = [self stringOfState:UIControlStateNormal];
    [_titleColors setObject:[UIColor blackColor] forKey:state];
    
}

- (void)setFrame:(CGRect)frame{
    CGSize oldSize = self.bounds.size;
    [super setFrame:frame];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        if (self.displaysAsynchronously) {
            [self _clearContents];
        }
        [self _setLayoutNeedRedraw];
    }
}

- (void)setBounds:(CGRect)bounds{
    CGSize oldSize = self.bounds.size;
    [super setBounds:bounds];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        if (self.displaysAsynchronously) {
            [self _clearContents];
        }
        [self _setLayoutNeedRedraw];
    }
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets forState:(UIControlState)state{
    
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    if (buttonInfo == nil) {
        
        buttonInfo = [ZEButtonInfo new];
        
        [_buttonInfos setObject:buttonInfo forKey:stateString];

    }
    
    buttonInfo.imageEdgeInsets = imageEdgeInsets;

}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets forState:(UIControlState)state{
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    if (buttonInfo == nil) {
        
        buttonInfo = [ZEButtonInfo new];
        
        [_buttonInfos setObject:buttonInfo forKey:stateString];
        
    }
    
    buttonInfo.titleEdgeInsets = titleEdgeInsets;

}

#pragma mark - 设置图标与文字的方向
- (void)setAlignmentStatus:(ZEButtonAlignmentStatus)alignmentStatus{
    
    ZEButtonAlignmentStatus old = self.alignmentStatus;
    
    ZEButtonAlignmentStatus new = alignmentStatus;
    
    if (old != new) {
        
        _alignmentStatus = alignmentStatus;
        
        if (self.displaysAsynchronously) {
            [self _clearContents];
        }
        [self _setLayoutNeedRedraw];
    }
    
}

#pragma mark - 根据状态设置title
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    if (buttonInfo == nil) {
        
        buttonInfo = [ZEButtonInfo new];
        
        [_buttonInfos setObject:buttonInfo forKey:stateString];
        
    }
    
    if (state == UIControlStateNormal) {
        
        if (_buttonInfos[[self stringOfState:UIControlStateHighlighted]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.title = title;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
        }
        else{
            
            ZEButtonInfo * highlightedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateHighlighted]];
            
            if ([highlightedButtonInfo.title isEqualToString:@""]) {
                
                highlightedButtonInfo.title = title;
                
                [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
                
            }
            
        }
        
        if (_buttonInfos[[self stringOfState:UIControlStateSelected]] == nil) {
            
            ZEButtonInfo * selectedButtonInfo = [ZEButtonInfo new];
            
            selectedButtonInfo.title = title;
            
            [_buttonInfos setObject:selectedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
        }
        else{
            
            ZEButtonInfo * selectedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateSelected]];
            
            if ([selectedButtonInfo.title isEqualToString:@""]) {
                
                selectedButtonInfo.title = title;
                
                [_buttonInfos setObject:selectedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
                
            }
            
            
        }
        
    }
    
    buttonInfo.title = title;
    
}

#pragma mark - 根据状态设置背景图片
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    if (buttonInfo == nil) {
        
        buttonInfo = [ZEButtonInfo new];
        
        [_buttonInfos setObject:buttonInfo forKey:stateString];

    }
    
    if (state == UIControlStateNormal) {
        
        if (_buttonInfos[[self stringOfState:UIControlStateHighlighted]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.backgroundImage = backgroundImage;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
        }
        else{
            
            ZEButtonInfo * highlightedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateHighlighted]];
            
            if (highlightedButtonInfo.backgroundImage ==nil) {
                
                highlightedButtonInfo.backgroundImage = backgroundImage;
                
                [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
                
            }
            
        }
        
        if (_buttonInfos[[self stringOfState:UIControlStateSelected]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.backgroundImage = backgroundImage;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
        }
        else{
            
            ZEButtonInfo * selectedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateSelected]];
            
            if (selectedButtonInfo.backgroundImage ==nil) {
                
                selectedButtonInfo.backgroundImage = backgroundImage;
                
                [_buttonInfos setObject:selectedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
                
            }
            
        }
        
    }
    
    buttonInfo.backgroundImage = backgroundImage;
}

#pragma mark - 根据状态设置图标
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    if (buttonInfo == nil) {
        
        buttonInfo = [ZEButtonInfo new];
        
        [_buttonInfos setObject:buttonInfo forKey:stateString];
        
        
    }
    
    if (state == UIControlStateNormal) {
        
        if (_buttonInfos[[self stringOfState:UIControlStateHighlighted]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.image = image;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
        }
        else{
            
            ZEButtonInfo * highlightedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateHighlighted]];
            
            if (highlightedButtonInfo.image ==nil) {
                
                highlightedButtonInfo.image = image;
                
                [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
                
            }
            
        }
        
        if (_buttonInfos[[self stringOfState:UIControlStateSelected]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.image = image;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
        }
        else{
            
            ZEButtonInfo * selectedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateSelected]];
            
            if (selectedButtonInfo.image == nil) {
                
                selectedButtonInfo.image = image;
                
                [_buttonInfos setObject:selectedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
                
            }
            
        }
        
    }
    
    buttonInfo.image = image;
}

#pragma mark - 根据状态设置字体颜色
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    if (buttonInfo == nil) {
        
        buttonInfo = [ZEButtonInfo new];
        
        [_buttonInfos setObject:buttonInfo forKey:stateString];
        
    }
    
    if (state == UIControlStateNormal) {
        
        if (_buttonInfos[[self stringOfState:UIControlStateHighlighted]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.titleColor = color;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
        }
        else{
            
            ZEButtonInfo * highlightedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateHighlighted]];
            
            if (highlightedButtonInfo.titleColor ==nil) {
                
                highlightedButtonInfo.titleColor = color;
                
                [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
                
            }
            
        }
        
        if (_buttonInfos[[self stringOfState:UIControlStateSelected]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.titleColor = color;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
        }
        else{
            
            ZEButtonInfo * selectedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateSelected]];
            
            if (selectedButtonInfo.titleColor ==nil) {
                
                selectedButtonInfo.titleColor = color;
                
                [_buttonInfos setObject:selectedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
                
            }
            
        }
        
    }
    
    buttonInfo.titleColor = color;
}

#pragma mark - 根据状态设置字体
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state{
    
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    if (buttonInfo == nil) {
        
        buttonInfo = [ZEButtonInfo new];
        
        [_buttonInfos setObject:buttonInfo forKey:stateString];

    }
    
    if (state == UIControlStateNormal) {
        
        if (_buttonInfos[[self stringOfState:UIControlStateHighlighted]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.titleFont = font;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
        }
        else{
            
            ZEButtonInfo * highlightedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateHighlighted]];
            
            if (highlightedButtonInfo.titleFont ==nil) {
                
                highlightedButtonInfo.titleFont = font;
                
                [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateHighlighted]];
                
            }
            
        }
        
        if (_buttonInfos[[self stringOfState:UIControlStateSelected]] == nil) {
            
            ZEButtonInfo * highlightedButtonInfo = [ZEButtonInfo new];
            
            highlightedButtonInfo.titleFont = font;
            
            [_buttonInfos setObject:highlightedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
        }
        else{
            
            ZEButtonInfo * selectedButtonInfo = _buttonInfos[[self stringOfState:UIControlStateSelected]];
            
            if (selectedButtonInfo.titleFont ==nil) {
                
                selectedButtonInfo.titleFont = font;
                
                [_buttonInfos setObject:selectedButtonInfo forKey:[self stringOfState:UIControlStateSelected]];
                
            }
            
        }
        
    }
    buttonInfo.titleFont = font;
    
}

-(NSString *)titleForState:(UIControlState)state{
    
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    return buttonInfo.title;
}

-(UIColor *)titleColorForState:(UIControlState)state{
    
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    return buttonInfo.titleColor;
}

-(UIImage *)imageForState:(UIControlState)state{
    
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    return buttonInfo.image;
}

-(UIImage *)backgroundImageForState:(UIControlState)state{
    
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    return buttonInfo.backgroundImage;
}

-(UIFont *)titleFontForState:(UIControlState)state{
    
    NSString *stateString = [self stringOfState:state];
    ZEButtonInfo * buttonInfo = _buttonInfos[stateString];
    
    return buttonInfo.titleFont;
}

#pragma mark - 计算title和image的绘制位置
- (void)actualUpdateSubviewFrames:(CGSize)size
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    _backgroundFrame = CGRectMake(0, 0, width, height);
    
    NSString * stateStr = [self stringOfState:self.state];
    
    ZEButtonInfo * buttonInfo = _buttonInfos[stateStr];
    
    if (buttonInfo.titleFont == nil) {
        
        buttonInfo.titleFont = [UIFont systemFontOfSize:15];
    }
    
    CGSize imageSize = buttonInfo.image.size;
    
    NSDictionary *attribute = @{NSFontAttributeName: buttonInfo.titleFont};
    CGSize titleSize = [buttonInfo.title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    CGFloat totalW = imageSize.width + titleSize.width;
    CGFloat left = (width - totalW) / 2.0f;
    
    
    switch (self.alignmentStatus) {
        case ZEButtonAlignmentStatusNormal:
        {
            if (imageSize.height > height) {
                
                CGFloat imageHeight = imageSize.width * height / imageSize.height;
                
                _imageFrame = CGRectMake(left + buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageHeight / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageHeight, height);
                
            }
            else{
                _imageFrame = CGRectMake(left + buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageSize.height / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageSize.width, imageSize.height);
            }
            
            _titleFrame = CGRectMake(CGRectGetMaxX(_imageFrame) + buttonInfo.titleEdgeInsets.left - buttonInfo.titleEdgeInsets.right, height / 2.0f - titleSize.height / 2.0f + buttonInfo.titleEdgeInsets.top - buttonInfo.titleEdgeInsets.bottom, titleSize.width, titleSize.height);
        }
            break;
        case ZEButtonAlignmentStatusLeft:
        {
            if (imageSize.height > height) {
                
                CGFloat imageHeight = imageSize.width * height / imageSize.height;
                
                _imageFrame = CGRectMake(buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageHeight / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageHeight, height);
                
            }
            else{
                _imageFrame = CGRectMake(buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageSize.height / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageSize.width, imageSize.height);
            }
            
            _titleFrame = CGRectMake(CGRectGetMaxX(_imageFrame) + buttonInfo.titleEdgeInsets.left - buttonInfo.titleEdgeInsets.right, height / 2.0f - titleSize.height / 2.0f + buttonInfo.titleEdgeInsets.top - buttonInfo.titleEdgeInsets.bottom, titleSize.width, titleSize.height);
        }
            break;
        case ZEButtonAlignmentStatusCenter:
        {
            _titleFrame = CGRectMake(left + buttonInfo.titleEdgeInsets.left - buttonInfo.titleEdgeInsets.right, height / 2.0f - titleSize.height / 2.0f + buttonInfo.titleEdgeInsets.top - buttonInfo.titleEdgeInsets.bottom, titleSize.width, titleSize.height);
            
            if (imageSize.height > height) {
                
                CGFloat imageHeight = imageSize.width * height / imageSize.height;
                
                _imageFrame = CGRectMake(CGRectGetMaxX(_titleFrame)  + buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageHeight / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageHeight, height);
                
            }
            else{
                _imageFrame = CGRectMake(CGRectGetMaxX(_titleFrame)  + buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageSize.height / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageSize.width, imageSize.height);
            }
        }
            break;
        case ZEButtonAlignmentStatusRight:
        {
            if (imageSize.height > height) {
                
                CGFloat imageHeight = imageSize.width * height / imageSize.height;
                
                _imageFrame = CGRectMake(self.bounds.size.width - imageSize.width + buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageHeight / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageHeight, height);
                
            }
            else{
                _imageFrame = CGRectMake(self.bounds.size.width - imageSize.width + buttonInfo.imageEdgeInsets.left - buttonInfo.imageEdgeInsets.right, height / 2.0f - imageSize.height / 2.0f + buttonInfo.imageEdgeInsets.top - buttonInfo.imageEdgeInsets.bottom, imageSize.width, imageSize.height);
            }
            
            _titleFrame = CGRectMake(CGRectGetMaxX(_imageFrame) - titleSize.width + buttonInfo.titleEdgeInsets.left - buttonInfo.titleEdgeInsets.right, height / 2.0f - titleSize.height / 2.0f + buttonInfo.titleEdgeInsets.top - buttonInfo.titleEdgeInsets.bottom, titleSize.width, titleSize.height);
        }
            break;
        case ZEButtonAlignmentStatusTop:
        {
            CGFloat totalH = imageSize.height + titleSize.height;
            CGFloat top = (height - totalH) / 2.0f + ZE_buttonTopRadio;
            if (imageSize.height > height) {
                
                CGFloat imageHeight = imageSize.width * height / imageSize.height;
                
                _imageFrame = CGRectMake((width - imageSize.width) * 0.5f, top, imageHeight, height);
                
            }
            else{
                _imageFrame = CGRectMake((width - imageSize.width) * 0.5f , top , imageSize.width, imageSize.height);
            }
            
            _titleFrame = CGRectMake((width - titleSize.width) * 0.5f, CGRectGetMaxY(_imageFrame) + ZE_buttonTopRadio, titleSize.width, titleSize.height);
            
        }
            break;
        case ZEButtonAlignmentStatusBottom:
        {
            CGFloat totalH = imageSize.height + titleSize.height;
            CGFloat top = (height - totalH) / 2.0f + ZE_buttonTopRadio;
            
            _titleFrame = CGRectMake((width - titleSize.width) * 0.5f, top , titleSize.width, titleSize.height);
            
            if (imageSize.height > height) {
                
                CGFloat imageHeight = imageSize.width * height / imageSize.height;
                
                _imageFrame = CGRectMake((width - imageSize.width) * 0.5f, CGRectGetMaxY(_titleFrame) + ZE_buttonTopRadio, imageHeight, height);
                
            }
            else{
                _imageFrame = CGRectMake((width - imageSize.width) * 0.5f , CGRectGetMaxY(_titleFrame) + ZE_buttonTopRadio , imageSize.width, imageSize.height);
            }
            
            
        }
            break;
        default:
            break;
    }
    
    
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
        
        NSString * stateStr = [weakSelf stringOfState:weakSelf.state];

        ZEButtonInfo * buttonInfo = _buttonInfos[stateStr];




        if (!buttonInfo) {
            return ;
        }

        [self actualUpdateSubviewFrames:size];


        UIImage *backgroundImage = buttonInfo.backgroundImage;
        UIImage *image = buttonInfo.image;
        UIColor *titleColor = buttonInfo.titleColor;
        NSString *title = buttonInfo.title;
        UIFont *titleFont = buttonInfo.titleFont;
        CGRect backgroundFrame = _backgroundFrame;
        CGRect imageFrame = _imageFrame;
        CGRect titleFrame = _titleFrame;


        CGContextSaveGState(context);
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        [backgroundImage drawInRect:backgroundFrame];

        if (isCancelled()) {
            CGContextRestoreGState(context);
            return;
        }

        [image drawInRect:imageFrame];
        if (title) {
            if (!titleFont) {
                titleFont = [UIFont systemFontOfSize:15.0f];
            }
            if (!titleColor) {
                titleColor = [UIColor blackColor];
            }
            NSDictionary *attribtues = @{NSFontAttributeName : titleFont, NSForegroundColorAttributeName : titleColor};
            [title drawInRect:titleFrame withAttributes:attribtues];
        } else {

        }
        _renderedImage = image;
        _renderedTitle = title;
        _renderedBackgroundImage = backgroundImage;


        CGContextRestoreGState(context);
    };
    
    
    task.didDisplay = ^(CALayer *layer,BOOL finished){
        if (!finished) {
            return ;
        }
        
        if (self.DisplayFinish) {
            self.DisplayFinish();
        }
        
        
    };
    
    return task;
    
}




@end

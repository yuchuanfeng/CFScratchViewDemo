//
//  CFScratchView.m
//  CFScratchView
//
//  Created by 于传峰 on 16/6/6.
//  Copyright © 2016年 于传峰. All rights reserved.
//

#import "CFScratchView.h"

@interface CFScratchView()
@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, weak) UIImageView *imageView;
@property( nonatomic, strong) NSMutableArray * points;

@property (nonatomic, assign) CGContextRef imageContext;
@property (nonatomic, assign) CGColorSpaceRef colorSpace;
@end

@implementation CFScratchView

- (CGColorSpaceRef)colorSpace{
    if (_colorSpace == NULL) {
        _colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    return _colorSpace;
}

- (NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}



- (instancetype)initWithImage:(UIImage *)image coverImage:(UIImage *)coverImage{
    if (self = [self initWithFrame:CGRectZero]) {
        self.imageView.image = image;
        self.coverImageView.image = coverImage;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView* coverImageView = [[UIImageView alloc] init];
        [self addSubview:coverImageView];
        self.coverImageView = coverImageView;
        
        UIImageView* imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.imageView.frame = self.bounds;
    self.coverImageView.frame = self.bounds;
    
    if (_imageContext != NULL) {
        CFRelease(_imageContext);
    }
    self.imageContext = CGBitmapContextCreate(0, frame.size.width, frame.size.height, 8, frame.size.width * 4, self.colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetStrokeColorWithColor(self.imageContext,[UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(self.imageContext, [UIColor redColor].CGColor);
    CGContextTranslateCTM(self.imageContext, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(self.imageContext, 1.0f, -1.0f);
    
    [self reCreateImageWithTouchDict:nil];
}

- (UIImage *)reCreateImageWithTouchDict:(NSDictionary *)touchDict{
    UITouch* touch = touchDict[@"touch"];
    CGFloat lineWidth = [touchDict[@"lineWidth"] floatValue] * 0.5;
    if (lineWidth < 1.0) {
        lineWidth = 10;
    }
    
    if (touch) {
        
        CGPoint point = [touch locationInView:touch.view];
        
        if (touch.phase == UITouchPhaseBegan) {
            CGRect rect = CGRectMake(point.x - lineWidth, point.y - lineWidth, lineWidth*2, lineWidth*2);
            CGContextAddEllipseInRect(self.imageContext, rect);
            CGContextFillPath(self.imageContext);
            
            [self.points removeAllObjects];
            [self.points addObject:[NSValue valueWithCGPoint:point]];
            
        }else if (touch.phase == UITouchPhaseMoved){
            [self.points addObject:[NSValue valueWithCGPoint:point]];
            if (self.points.count > 2) {
                CGContextSetLineCap(self.imageContext, kCGLineCapRound);
                CGContextSetLineWidth(self.imageContext, 2 * lineWidth);
                do{
                    CGPoint point0 = [(NSValue *)self.points[0] CGPointValue];
                    CGPoint point1 = [(NSValue *)self.points[1] CGPointValue];
                    CGContextMoveToPoint(self.imageContext, point0.x, point0.y);
                    CGContextAddLineToPoint(self.imageContext, point1.x, point1.y);
                    [self.points removeObjectAtIndex:0];
                }while (self.points.count > 2);
                
            }
        }
        
        
        CGContextStrokePath(self.imageContext);
    }

    
    CGImageRef cgImage = CGBitmapContextCreateImage(self.imageContext);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)image.CGImage;
    mask.anchorPoint = CGPointZero;
    mask.frame = self.bounds;
    self.imageView.layer.mask = mask;
    self.imageView.layer.masksToBounds = YES;
    
    return image;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    [self reCreateImageWithTouchDict:@{@"touch":touch, @"lineWidth":@(touch.majorRadius)}];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    [self reCreateImageWithTouchDict:@{@"touch":touch, @"lineWidth":@(touch.majorRadius)}];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)recover{
    CGContextClearRect(self.imageContext, self.bounds);
    [self reCreateImageWithTouchDict:nil];
}

- (void)dealloc{
    if (_imageContext != NULL) {
        CFRelease(_imageContext);
    }
    
    if (_colorSpace != NULL) {
        CFRelease(_colorSpace);
    }
}

@end

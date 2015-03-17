//
//  PLLCircleImageView.m
//  DemoForCircleImageView
//
//  Created by liu poolo on 14-8-4.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import "PLLCircleImageView.h"

@implementation PLLCircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque=NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef imageCtx=UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(imageCtx, CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect)));
    CGContextDrawPath(imageCtx, kCGPathFill);
    CGImageRef mask=CGBitmapContextCreateImage(imageCtx);
    CGContextClipToMask(ctx, rect, mask);
    UIGraphicsEndImageContext();
    
    CGImageRelease(mask);
    
    [_showImage drawInRect:rect];
}

-(void)setShowImage:(UIImage *)showImage{
    if(_showImage!=showImage){
        _showImage=showImage;
        [self setNeedsDisplay];
    }
}


@end

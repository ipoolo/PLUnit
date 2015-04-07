//
//  UIView+ScreenShot.m
//  PLUnit
//
//  Created by liu poolo on 15/4/7.
//  Copyright (c) 2015年 liu poolo. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)
-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

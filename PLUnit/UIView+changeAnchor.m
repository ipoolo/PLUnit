//
//  UIView+changeAnchor.m
//  teststststs
//
//  Created by liu poolo on 15/5/8.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "UIView+changeAnchor.h"

@implementation UIView (changeAnchor)
-(void)changeAnchorPoint:(CGPoint)targetAnchorPoint{
    
    [self.layer setPosition:CGPointMake(self.frame.origin.x+self.bounds.size.width*targetAnchorPoint.x, self.frame.origin.y+self.bounds.size.height*targetAnchorPoint.y)];
    [self.layer setAnchorPoint:CGPointMake(targetAnchorPoint.x, targetAnchorPoint.y)];
}
@end

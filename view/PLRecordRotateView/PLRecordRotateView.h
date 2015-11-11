//
//  RecordRotateView.h
//  RecordRotate
//
//  Created by liu poolo on 15/11/9.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLRecordRotateView : UIView
-(instancetype)initWithFrame:(CGRect)frame images:(NSArray*)imagesArray;
-(void)transformViewWithDistance:(CGFloat)distance;
-(void)setImage:(UIImage*) image atIndex:(int) index;
@end

//
//  RecordRotateView.m
//  RecordRotate
//
//  Created by liu poolo on 15/11/9.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "PLRecordRotateView.h"
@interface PLRecordRotateView(){
    
}
@property (copy,nonatomic) NSArray *recordViewArray;
@property (copy,nonatomic) NSArray *recordAngleArray;
@property (assign,nonatomic) BOOL haveImages;

@property (assign,nonatomic) float sideLenght;
@end

@implementation PLRecordRotateView

const float minAngle = -M_PI_2;
const float maxAngle = M_PI_2;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [self initWithFrame:frame images:nil];
    if(self){
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray*)imagesArray{
    self = [super initWithFrame:frame];
    if(self){
        NSUInteger imageCount = [imagesArray count];
        imageCount = imageCount?imageCount:5;
        self.haveImages = imageCount;

        self.sideLenght = CGRectGetWidth(frame)/imageCount;
        self.recordAngleArray = @[@(-2*M_PI/imageCount),@(-M_PI/imageCount),@0,@(M_PI/imageCount),@(2*M_PI/imageCount)];
        
        NSMutableArray* tmpArray = [@[] mutableCopy];
        for(int i=0 ; i<imageCount; i++){
            UIImageView *tmpView = [[UIImageView alloc] init];
            [self addSubview:tmpView];
            tmpView.bounds = CGRectMake(0, 0, self.sideLenght, self.sideLenght);
            tmpView.center = self.center;
            UIColor *viewBgColor;
            switch (i) {
                case 0:
                    viewBgColor = [UIColor redColor];
                    break;
                case 1:
                    viewBgColor = [UIColor orangeColor];
                    break;
                case 2:
                    viewBgColor = [UIColor yellowColor];
                    break;
                case 3:
                    viewBgColor = [UIColor greenColor];
                    break;
                default:
                    viewBgColor = [UIColor blueColor];
                    break;
            }
            [tmpView setBackgroundColor:viewBgColor];
            if(self.haveImages){
                [tmpView setImage:imagesArray[i]];
            }
            [tmpArray addObject:tmpView];
        }
        
        self.recordViewArray = tmpArray;
        
        CATransform3D tmpCAF = CATransform3DIdentity;
        tmpCAF.m34 = - 1.f / 1000;
        [self.layer setSublayerTransform:tmpCAF];
        
        [self transformViewWithAngle:0];
        

        
    }
    return self;
}

-(void)setImage:(UIImage*) image atIndex:(int) index{
    [self.recordViewArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        if(index == idx){
            [imageView setImage:image];
        }
    }];
}

-(void)transformViewWithDistance:(CGFloat)distance{
    [self transformViewWithAngle:distance/(2*self.sideLenght)*M_PI_2*-1];
}

-(void)transformViewWithAngle:(CGFloat)angle {
    [self.recordViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self transformViewWithAngle:angle layerIndex:idx];
    }];
}

-(void)transformViewWithAngle:(CGFloat)angle layerIndex:(NSUInteger) index{
    CGFloat transformAngle = [self.recordAngleArray[index] doubleValue]+angle;
    if(transformAngle > maxAngle){
        transformAngle = minAngle + fabs(transformAngle-maxAngle);
    }else if(transformAngle < minAngle){
        transformAngle = maxAngle - fabs(transformAngle-minAngle);
    }
    [self.layer setAllowsEdgeAntialiasing:YES];
    NSMutableArray *muArray = [self.recordAngleArray mutableCopy];
    muArray[index] = @(transformAngle);
    self.recordAngleArray = muArray;
    
    CGFloat transformX = transformAngle*(-1.0f)/M_PI_2*2.5f*self.sideLenght;

    UIView *tmpView = self.recordViewArray[index];
    CATransform3D tmpCTF;
    tmpCTF = CATransform3DMakeTranslation(transformX, 0, 0);
    tmpCTF = CATransform3DRotate(tmpCTF, transformAngle, 0, 1, 0);
    tmpView.layer.transform = tmpCTF;
}

@end

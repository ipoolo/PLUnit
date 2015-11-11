//
//  ReflectView.m
//  specialLayer
//
//  Created by liu poolo on 15/11/11.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "PLReflectView.h"

@implementation PLReflectView

+(Class)layerClass{
    return [CAReplicatorLayer class];
}


- (void)setup{
    CAReplicatorLayer *cLayer = (CAReplicatorLayer *)self.layer;
    cLayer.instanceCount = 2;

    
    CATransform3D transform3d = CATransform3DIdentity;
    transform3d = CATransform3DTranslate(transform3d, 0, CGRectGetHeight(self.layer.bounds)+2, 0);
    transform3d = CATransform3DScale(transform3d, 1.f, -1.f, 0.f);

    cLayer.instanceTransform = transform3d;
    cLayer.instanceAlphaOffset = -0.6;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}


-(void)awakeFromNib{
    [self setup];
}

@end

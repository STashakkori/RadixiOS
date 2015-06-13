//
//  DWFParticleView.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DWFParticleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DWFParticleView
{
    CAEmitterLayer* fireEmitter; //1
}

-(void)awakeFromNib
{
    //set ref to the layer
    fireEmitter = (CAEmitterLayer*)self.layer; //2
    //configure the emitter layer
    fireEmitter.emitterPosition = CGPointMake(50, 50);
    fireEmitter.emitterSize = CGSizeMake(10, 10);
    fireEmitter.renderMode = kCAEmitterLayerAdditive;
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = 200;
    fire.lifetime = 1.0;
    fire.lifetimeRange = 0.2;
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] 
                  CGColor];
    fire.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
    fire.velocity = 10;
    fire.velocityRange = 20;
    fire.emissionRange = M_PI_2;
    fire.scaleSpeed = 0.3;
    fire.spin = 0.5;
    [fire setName:@"fire"];
    
    //add the cell to the layer and we're done
    fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

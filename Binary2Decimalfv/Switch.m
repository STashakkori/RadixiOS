//
//  Switch.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Switch.h"


@implementation Switch

-(id)init
{
    if((self = [super init])){
        state = 0;
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

// method for looping through the animations from a frame image number to another frame image number
-(CCAnimation*)animationForwardWithFrames:(int)from to:(int)to{
    //NSMutableArray *animeArray = [NSMutableArray array];
    CCAnimation *animation = [[[CCAnimation alloc] init] autorelease];
    for (int i = from; i <= to; i++) {
        [animation addFrameWithFilename:[NSString stringWithFormat:@"switch0%iv8.png",i]];
    }
    [animation setDelay:0.085f];
    return animation;
}

// method for looping through the animations in reverse from a frame image number to another frame image number
-(CCAnimation*)animationBackwardWithFrames:(int)from to:(int)to{
    //NSMutableArray *animeArray = [NSMutableArray array];
    CCAnimation *animation = [[[CCAnimation alloc] init] autorelease];
    for (int i = from; i >= to; i--) {
        [animation addFrameWithFilename:[NSString stringWithFormat:@"switch0%iv8.png",i]];
    }
    [animation setDelay:0.05f];
    return animation;
}
-(void)resetSwitch
{
    if(state == 1){
        [self stopAllActions];
        // animate the hit animation
        [self runAction:[CCAnimate actionWithAnimation:[self animationBackwardWithFrames:2 to:0] restoreOriginalFrame:NO]];
        // set the mole no longer up
        state = 0;
    }
        
}
       
-(void)isTapped
{
    // double-check to see if mole is up
    if (state == 0) 
    {
        // stop all actions
        [self stopAllActions];
        // animate the hit animation
        [self runAction:[CCAnimate actionWithAnimation:[self animationForwardWithFrames:0 to:2] restoreOriginalFrame:NO]];
        state = 1;
    } else {
        [self stopAllActions];
        // animate the hit animation
        [self runAction:[CCAnimate actionWithAnimation:[self animationBackwardWithFrames:2 to:0] restoreOriginalFrame:NO]];
        // set the mole no longer up
        state = 0;
    }
}
       


@end

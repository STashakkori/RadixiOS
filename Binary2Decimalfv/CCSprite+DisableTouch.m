//
//  CCSprite+DisableTouch.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite+DisableTouch.h"


@implementation CCSprite (DisableTouch)

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)disableTouch
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1000 swallowsTouches:YES];
}

-(void)enableTouch
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

@end

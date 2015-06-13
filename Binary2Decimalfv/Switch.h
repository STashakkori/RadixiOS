//
//  Switch.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class AppDelegate;

@interface Switch : CCSprite
{
    int state;
    AppDelegate *delegate;
}

-(void)isTapped;
-(CCAnimation *)animationForwardWithFrames:(int)from to:(int)to;
-(CCAnimation*)animationBackwardWithFrames:(int)from to:(int)to;
-(void)resetSwitch;
@end

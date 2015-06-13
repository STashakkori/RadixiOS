//
//  CCSprite+DisableTouch.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CCSprite (DisableTouch) <CCTargetedTouchDelegate>  

-(void)disableTouch;
-(void)enableTouch;

@end

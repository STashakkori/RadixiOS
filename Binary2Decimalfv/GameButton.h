//
//  GameButton.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface GameButton: CCSprite
{
    
}

+(id)buttonWithText: (NSString *)buttonText isBig:(BOOL)big;
+(id)buttonWithText: (NSString *)buttonText;
-(id)initWithText: (NSString *)buttonText isBig:(BOOL)big;


@end
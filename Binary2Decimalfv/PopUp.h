//
//  PopUp.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface PopUp : CCSprite
{
    CCSprite *window,*bg;
    CCNode *container;
}

+ (id)popUpWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite background:(NSString *)background;
- (id)initWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite background:(NSString *)background;

- (void)closePopUp;

@end

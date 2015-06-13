//
//  CCMenuPopup.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCMenuPopup.h"
#import "PopUp.h"

@interface CCMenu (missing)
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
- (CCMenuItem *)itemForTouch:(UITouch *)touch;
#elif __MAC_OS_X_VERSION_MAX_ALLOWED
- (CCMenuItem *)itemForMouseEvent:(NSEvent *)event;
#endif
@end

@implementation CCMenuPopup

-(void)registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1001 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![super itemForTouch:touch]) {
        return NO;
    }
    NSArray *ancestors = [NSArray arrayWithObjects:self.parent,self.parent.parent,self.parent.parent.parent, nil];
    for (CCNode *n in ancestors) {
        if ([n isKindOfClass:[PopUp class]]) {
            [(PopUp *)n closePopUp];
        }
    }
    
    return [super ccTouchBegan:touch withEvent:event];
}

@end

//
//  PopUp.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PopUp.h"
#import "CCSprite+DisableTouch.h"
#import "CCMenuPopup.h"

#define ANIM_SPEED .2f

@implementation PopUp

enum tags
{
    tBG = 1,
};

+ (id)popUpWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite background:(NSString *)background
{
    return [[[self alloc] initWithTitle:titleText description:description sprite:sprite background:background] autorelease];
}

- (id)initWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite background:(NSString *)background
{
    self = [super init];
    if (self)
    {
        CGSize s = [[CCDirector sharedDirector] winSize];
        container = sprite;
        window = [CCSprite spriteWithFile:background];
        bg = [CCSprite node];
        bg.color = ccBLACK;
        bg.opacity = 0;
        [bg setTextureRect:CGRectMake(0, 0, s.width, s.height)];
        bg.anchorPoint = ccp(0,0);
        [bg disableTouch];
        window.position = ccp(s.width/2, s.height/2);
        window.scale = .9;
        int fSize = 36;
        CCLabelTTF *title = [CCLabelTTF labelWithString:titleText fontName:@"Marker Felt" fontSize:fSize];
        title.color = ccBLACK;
        //title.opacity = (float)255 * .5f;
        title.position = ccp(window.position.x, window.position.y + window.contentSize.height/2.75);
        CCLabelTTF *desc = [CCLabelTTF labelWithString:description fontName:@"Marker Felt" fontSize:fSize/1.5];
        
        desc.position = ccp(title.position.x, title.position.y - title.contentSize.height/1.25);
        desc.color = ccBLACK;
        //desc.opacity = (float)255 * .5f;
        [window addChild:title z:1];
        [window addChild:desc];
        [self addChild:bg z:-1 tag:tBG];
        [self addChild:window];
        
        [window addChild:container z:2];
        [bg runAction:[CCFadeTo actionWithDuration:ANIM_SPEED / 2 opacity:150]];
        [window runAction:[CCSequence actions:
                           [CCScaleTo actionWithDuration:ANIM_SPEED /2 scale:1.1],
                           [CCScaleTo actionWithDuration:ANIM_SPEED /2 scale:1.0],
                           nil]];
    }
    return self;
}

- (void)closePopUp
{
    [(CCSprite *)[self getChildByTag:tBG] enableTouch];
    [window runAction:[CCFadeOut actionWithDuration:ANIM_SPEED]];
    [window runAction:[CCSequence actions:
                       [CCScaleTo actionWithDuration:ANIM_SPEED scale:1.1],
                       [CCCallFunc actionWithTarget:self selector:@selector(allDone)],
                       nil]];
}

- (void)allDone
{
    [self removeFromParentAndCleanup:YES];
}


@end
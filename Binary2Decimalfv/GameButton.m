//
//  GameButton.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameButton.h"

@implementation GameButton

+(id)buttonWithText: (NSString *)buttonText isBig:(BOOL)big
{
    return [[[GameButton alloc] initWithText:buttonText isBig:big] autorelease];
}

+(id)buttonWithText: (NSString *)buttonText
{
    return [[[GameButton alloc] initWithText:buttonText isBig:NO] autorelease];
}

-(id)initWithText: (NSString *)buttonText isBig:(BOOL)big
{
    if(self == [super init])
    {
        NSString *fileName = [NSString stringWithFormat:@"moles.plist"];
        // add sprites from file
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileName];
        NSString *btnFrame = (big) ? @"button_big.png" : @"button_small.png";
        int fSize = 12;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:btnFrame]];
        CCLabelTTF *label = [CCLabelTTF labelWithString:buttonText fontName:@"Marker Felt" fontSize:fSize + big * fSize];
        label.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:label z:1];
        CCLabelTTF *labelShadow = [CCLabelTTF labelWithString:buttonText fontName:@"Marker Felt" fontSize:fSize + big * fSize];
        labelShadow.position = ccp(self.contentSize.width/2 - (2 + big * 2), self.contentSize.height/2);
        labelShadow.color = ccBLACK;
        labelShadow.opacity = 150;
        [self addChild:labelShadow];
    }
    return self;
}

@end
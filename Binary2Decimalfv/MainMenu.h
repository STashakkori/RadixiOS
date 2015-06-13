//
//  MainMenu.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class AppDelegate;

@interface MainMenu : CCScene
{
    AppDelegate *delegate;
    BOOL isBinary;
    BOOL isTwosComp;
    CCSprite *play;
    CCLabelTTF *binaryHighScoreLabel;
    CCLabelTTF *twosComplementHighScoreLabel;
    CCLabelTTF *baseChangerHighScoreLabel;
    UITextView *description;
    BOOL showHelp;
}

- (void)selectBitLevel;
- (void)gameMultiplexer:(CCMenuItemImage *)sender;
- (void)play:(CCMenuItemImage *)sender;
- (void)selectBits:(CCMenuItemImage *)sender;
- (void)selectGame;
- (void)playButtonTapped;
- (CCAnimation*)animationForwardWithFrames:(int)from to:(int)to;
- (void)startBaseChanger;
@end
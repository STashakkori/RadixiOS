//
//  GameScene.h
//  Binary2Decimalfv
//
//  Created by Ahmad on 2/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class AppDelegate;

@interface GameScene : CCLayer
{
    AppDelegate *delegate;
    CCArray* switches;
    CCSprite* background;
    int* switch_state;
    int max;
    float switchImageHeight;
    float switchImageWidth;
    int numberInDecimal,numberInBinary;
    CCLabelTTF* binaryNumber;
    CCLabelTTF* decimalNumberLabel;
    CCLabelTTF* scoreLabel;
    CCLabelTTF* targetLabel;
    //CCArray* numbersInBinary;
    int numberOfBits;
    int targetNumber;
    int currentNumber;
    int currentScore;
    BOOL isPaused;
    CCLabelTTF* timeLabel;
    CCLabelTTF *highScoreLabel;
    int time;
    CCMenuItemSprite *pauseButton;
    CCMenuItemSprite *gameOverButton;
    CGSize screenSize;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) sceneWithNumberOfBits:(int)Number;
- (void)pauseGame;
- (void)resumeGame;
- (void)gameOver;

@end

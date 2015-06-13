//
//  TwosComplement.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 3/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BCMenu.h"

@class AppDelegate;

@interface TwosComplement : CCLayer
{
    AppDelegate *delegate;
    CCArray* switches;
    CCSprite* background;
    int* switch_state;
    int max, min;
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
    CGSize screenSize;
}

+(CCScene *) sceneWithNumberOfBits:(int)Number;
-(void)pauseGame;
-(void)resumeGame;

@end
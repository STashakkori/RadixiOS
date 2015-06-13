//
//  baseChanger.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Switch.h"
#import "GameButton.h"
#import "CCMenuPopup.h"
#import "PopUp.h"
#import "DWFParticleView.h"

@interface BaseChanger : CCLayer <UIPickerViewDataSource,UIPickerViewDelegate> {
   
    AppDelegate *delegate;
    
    UIView *myView;
    UIView *pauseView;
    UIPickerView* digitPicker;
    UIButton* start;                /* buttton for starting the game */
    UIButton* returnButton;         /* buttton for returning to the main menu */
    UILabel* targetLabel;
    UILabel* scoreLabel;
    UILabel* currentLabel;
    UILabel* highScoreLabel;        /* label for showing the high score */
    
    CGSize screenSize;  
    NSArray* _digits;               /* Array for UIPickerView */
    NSMutableArray *digit_labels;   /* Mutable array for labels */
    
    int newBase;
    int oldBase;
    long maxTarget;
    long maxInput;
    long maxNumber;
    long decimalTarget;
    int currentScore;
    NSMutableString *stringDecimalTarget;
    NSMutableString *stringTarget;
    NSMutableString *stringCurrent;
    
    UILabel* timeLabel;
    int time;
    BOOL timing;
    BOOL activateTiming;
    BOOL isGameStarted;
    
}
+(CCScene *) sceneWithBase:(int)inputBase toBase:(int)outputBase withTiming:(BOOL)havetiming;
-(void)buttonPressed;
-(void)returnButtonPressed;
@end

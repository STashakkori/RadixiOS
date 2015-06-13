//
//  BCMenu.h
//  Binary2Decimalfv
//
//  Created by Ahmad on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Switch.h"
#import "GameButton.h"
#import "CCMenuPopup.h"
#import "PopUp.h"
#import "baseChanger.h"


@interface BCMenu : CCLayer <UIPickerViewDataSource,UIPickerViewDelegate> {
    
    UIPickerView* digitPicker;
    UIButton* start;
    CGSize screenSize;
    NSArray* _digits;
    UILabel* ChangeFromLabel;
    UILabel* ChangeToLabel;
    int newBase;
    int oldBase;
    UIView *myView;
    UIView *pauseView;
    BOOL timing;
    
}
+(CCScene *)sceneWithTimingState:(BOOL)havetiming;
-(void)buttonPressed;
@end

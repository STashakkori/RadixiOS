//
//  GameScene.m
//  Binary2Decimalfv
//
//  Created by Ahmad on 2/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "constant.h"
@interface GameScene (PrivateMethods)
-(void) initBinaryCodes;
-(void) resetBinaryCodes;
-(void) updateLabels;
-(void) initSwitches;
-(void)drawSwitches;
-(int)whatSwitchwithLocation:(CGPoint)touchLocation;
@end



@implementation GameScene


+(id) scene 
{ 
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
} 

-(id) init 
{ 
    if ((self = [super init])) 
    { 
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self); 
        self.isTouchEnabled = YES;
        
        numberInBinary = 0;
        numberInDecimal = 0;
        targetNumber = arc4random()%15;
        targetNumber ++;
        currentScore = 0;
        currentNumber = 0;
        numberOfBits = 4;
        background = [CCSprite spriteWithFile:@"green.png"];
        [self addChild:background z:-2 tag:BACKGROUND];
        
       
        
        /*e_switch0 = [CCSprite spriteWithFile:@"switch.png"];
        [self addChild:e_switch0 z:0 tag:FIRST_BIT];
        e_switch1 = [CCSprite spriteWithFile:@"switch1.png"];
        [self addChild:e_switch1 z:1 tag:SECOND_BIT];
        e_switch2 = [CCSprite spriteWithFile:@"switch.png"];
        [self addChild:e_switch2 z:2 tag:THIRD_BIT];
        e_switch3 = [CCSprite spriteWithFile:@"switch.png"];
        [self addChild:e_switch3 z:3 tag:FOURTH_BIT];
        */
        
        
        for (int i=0; i<numberOfBits; i++) {
            switch_state[i]=0;
        }
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        e_switch0 = [CCSprite spriteWithFile:@"switch.png"];
        switchImageHeight = [[e_switch0 texture] contentSize].height;
        switchImageWidth = [[e_switch0 texture] contentSize].width;
        
        
        [self initSwitches];
        [self drawSwitches];
        
        [self initBinaryCodes];
        [self resetBinaryCodes];
        
        
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        /*e_switch0.position = CGPointMake(screenSize.width/4, screenSize.height/2);
        e_switch1.position = CGPointMake(screenSize.width/4+switchImageWidth*1.3, screenSize.height/2);
        e_switch2.position = CGPointMake(screenSize.width/4+switchImageWidth*2.6, screenSize.height/2);
        e_switch3.position = CGPointMake(screenSize.width/4+switchImageWidth*3.9, screenSize.height/2);
        */
        
        
        //binaryNumber = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
        //binaryNumber.anchorPoint = CGPointMake(0.5f, 1.0f);
        //binaryNumber.position = CGPointMake(screenSize.width*0.9, screenSize.height*0.1);
        //[self addChild:binaryNumber z:-1 tag:5];
        decimalNumber = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",currentNumber] fontName:@"Arial" fontSize:24];
        decimalNumber.anchorPoint = CGPointMake(0.5f, 1.0f);
        decimalNumber.position = CGPointMake(screenSize.width*0.1, screenSize.height*0.9);
        [self addChild:decimalNumber z:-1 tag:6];
        score = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
        score.anchorPoint = CGPointMake(0.5f, 1.0f);
        score.position = CGPointMake(screenSize.width*0.9, screenSize.height*0.9);
        [self addChild:score z:-1 tag:7];
        
        
        
        
        
        target = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",targetNumber] fontName:@"Arial" fontSize:24];
        target.anchorPoint = CGPointMake(0.5f, 1.0f);
        target.position = CGPointMake(screenSize.width*0.5, screenSize.height*0.1);
        [self addChild:target z:-1 tag:8];

        
    } 
    
    return self; 
}

-(void) initSwitches
{
    switches = [[CCArray alloc] initWithCapacity:numberOfBits];
    for (int i=0; i<numberOfBits; i++) {
        CCSprite* e_switch = [CCSprite spriteWithFile:@"switch.png"];
        [self addChild:e_switch z:1 tag:FIRST_BIT];
        [switches addObject:e_switch];
    }
}
-(void)drawSwitches
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    for (int i=0; i<numberOfBits; i++) {
        CCSprite* temp = [switches objectAtIndex:i];
        temp.position = CGPointMake(screenSize.width/4+switchImageWidth*i*1.3, screenSize.height/2);
    }
}

-(int)whatSwitchwithLocation:(CGPoint)touchLocation
{
    //find out if the touch is in the bounding box
    for (int i=0; i<numberOfBits; i++) {
        CCNode* node = [switches objectAtIndex:i];
        BOOL m = CGRectContainsPoint([node boundingBox], touchLocation);
        if (m) {
            return i;
        }
    }
    return -1;
}

-(void) checkWin
{
    if (currentNumber == targetNumber) {
        currentScore = currentScore + 10;
        targetNumber = arc4random()%15;
        targetNumber ++;
        [self updateLabels];
    }
}
-(void) updateLabels
{
    [decimalNumber setString:[NSString stringWithFormat:@"%d",currentNumber]];
    [target setString:[NSString stringWithFormat:@"%d",targetNumber]];
    [score setString:[NSString stringWithFormat:@"%d",currentScore]];
}
-(void) initBinaryCodes
{
    numbersInBinary = [[CCArray alloc] initWithCapacity:numberOfBits];
    
    for (int i = 0; i < numberOfBits; i++)
	{
		// Creating a spider sprite, positioning will be done later
		CCLabelTTF* tempfont = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
		[self addChild:tempfont z:0 tag:2];
		
		// Also add the spider to the spiders array so it can be accessed more easily.
		[numbersInBinary addObject:tempfont];
	}
}

-(void)resetBinaryCodes
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    for (int i=0; i<numberOfBits; i++) {
        CCLabelTTF* temp = [numbersInBinary objectAtIndex:i];
        temp.position = CGPointMake(screenSize.width/4+switchImageWidth*i*1.3, screenSize.height/3);
    }
}



-(void) registerWithTouchDispatcher 
{ 
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:-1  
                                              swallowsTouches:YES]; 
}
-(void)changeSwitchState:(int)switchNumber
{
    if (switch_state[switchNumber]==0)
        switch_state[switchNumber]=1;
    else
        switch_state[switchNumber]=0;
    CCLabelTTF* temp = [numbersInBinary objectAtIndex:switchNumber];
    [temp setString:[NSString stringWithFormat:@"%d",switch_state[switchNumber]]];
}

-(void)updateBinaryNumber
{
    numberInBinary = 1000 * switch_state[0] + 100 * switch_state[1] + 10 * switch_state[2] + switch_state[3];
}

-(void)updateDecimalNumber
{
    numberInDecimal = 8 * switch_state[0] + 4 * switch_state[1] + 2 * switch_state[2] + switch_state[3];
    currentNumber = numberInDecimal;
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    //find the location of touch in here
    CGPoint touchLocation = [touch locationInView: [touch view]];
	/*CGPoint location = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    //find out if the touch is in the bounding box
    CCNode* node = [self getChildByTag:FIRST_BIT]; 
    BOOL m = CGRectContainsPoint([node boundingBox], touchLocation);
    if (m) {
        [self changeSwitchState:0];
    }
    node = [self getChildByTag:SECOND_BIT]; 
    m = CGRectContainsPoint([node boundingBox], touchLocation);
    if (m) {
        [self changeSwitchState:1];
    }
    node = [self getChildByTag:THIRD_BIT]; 
    m = CGRectContainsPoint([node boundingBox], touchLocation);
    if (m) {
        [self changeSwitchState:2];
    }
    node = [self getChildByTag:FOURTH_BIT]; 
    m = CGRectContainsPoint([node boundingBox], touchLocation);
    if (m) {
        [self changeSwitchState:3];
    }*/
    int check = [self whatSwitchwithLocation:touchLocation];
    if (check == -1) {
        return NO;
    }
    [self changeSwitchState:check];
    
    for (int i=0; i<4; i++) {
        CCLOG(@"%d",switch_state[i]);
    }
    [self updateBinaryNumber];
    [self updateDecimalNumber];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    //CCLOG(@"\nthe width is: %f and the height is: %f",location.x,location.y);
    CCLOG(@"\nthe width is: %f and the height is: %f",screenSize.width,screenSize.height);
    
    //NSString* stringBinaryNumber = [NSString stringWithFormat:@"%d",numberInBinary];
    NSString* stringDecimalNumber = [NSString stringWithFormat:@"%d",numberInDecimal];
    
    //[binaryNumber setString:stringBinaryNumber];
    [decimalNumber setString:stringDecimalNumber];
    
    [self checkWin];
    
    return YES;
}
-(void) dealloc 
{ 
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self); 
    
    // never forget to call [super dealloc] 
    [numbersInBinary release];
    [super dealloc]; 
} 


@end

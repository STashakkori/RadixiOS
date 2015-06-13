//
//  GameScene.m
//  Binary2Decimalfv
//
//  Created by Ahmad on 2/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "constant.h"
#import "MainMenu.h"
#import "AppDelegate.h"
#import "PopUp.h"
#import "GameButton.h"
#import "CCMenuPopup.h"
#import "Switch.h"
#import "baseChanger.h"
#import "CCParticleSystemQuad.h"
#import "BCMenu.h"
#import "unistd.h"

@interface GameScene (PublicMethods)
-(id) initWithNumbersOfBits:(int)Number;
-(void) resetBitsandCurrent;
-(void) changeSwitchImageState:(int)number;
-(void) initBinaryCodes;
-(void) initLabelsWithScreenSize;
-(void) drawBinaryDigitsWithScreenSize;
-(void) updateLabels;
-(void) initSwitches;
-(void) drawSwitchesWithScreenSize;
-(void) burstOnSwitch:(Switch *)sender;
-(int) whatSwitchwithLocation:(CGPoint)touchLocation;
-(NSString *) changeBaseFrom:(NSString *)iNumber base:(int)iBase to:(int)outputBase;
@end



@implementation GameScene

+(id)sceneWithNumberOfBits:(int)Number
{ 
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	//GameScene *layer = [GameScene node];
	GameScene *layer = [[[GameScene alloc] initWithNumbersOfBits:Number] autorelease];
    //[layer autorelease];
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
} 

-(id)initWithNumbersOfBits:(int)Number
{ 
    if ((self = [super init])) 
    { 
        //enabling touch
        self.isTouchEnabled = YES;
        
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //initialize numbers
        time = 100;
        numberInBinary = 0;
        numberInDecimal = 0;
        currentScore = 0;
        currentNumber = 0;
        numberOfBits = Number;
        max = (int)pow(2, numberOfBits) - 1;
        targetNumber = arc4random()%max;
        targetNumber ++;
    
        screenSize = [[CCDirector sharedDirector] winSize];
        
        //adding background to the scene
        background = [CCSprite spriteWithFile:@"gamebgv1.png"];
        [self addChild:background z:-2 tag:BACKGROUND];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        

       
        //define and initialize the state of the bits
        switch_state = malloc(numberOfBits*sizeof(int));
        for (int i=0; i<numberOfBits; i++) {
            switch_state[i]=0;
        }
        
        //find the size of switch image
        CCSprite *e_switch0 = [Switch spriteWithFile:@"switch00v8.png"];
        switchImageHeight = [[e_switch0 texture] contentSize].height;
        switchImageWidth = [[e_switch0 texture] contentSize].width;
        
        // set pause button file and method selector
        pauseButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"pausebuttonv2.png"] selectedSprite:NULL target:self selector:@selector(pauseGame)];
        // create menu and add pause button
        CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
        
        // set position of pause button (bottom right)
        pauseButton.position = ccp(screenSize.width/2 - pauseButton.contentSize.width/2, (-screenSize.height/2) + pauseButton.contentSize.height/2);
        
        // add pause button to view
        [self addChild:menu z:100];
        
        //initialize and draw the switches
        [self initSwitches];
        [self drawSwitchesWithScreenSize];
        
        //initialize and draw the numbers in binary
        //[self initBinaryCodes];
        //[self drawBinaryDigitsWithScreenSize];
        
        //initialize labels
        [self initLabelsWithScreenSize];
        [self schedule:@selector(countDown:) interval:1.0f]; 
    } 
    return self; 
}

-(void)countDown:(ccTime)delta
{
    time--;
    [timeLabel setString:[NSString stringWithFormat:@"%d",time]];
    if (time <= 0) {
        [self unschedule:@selector(countDown:)];
        //when the time finishes
        [self gameOver];
    }
}

-(void)initLabelsWithScreenSize
{    
    //adding label for decimal Number
    decimalNumberLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",currentNumber] fontName:@"Arial" fontSize:24];
    decimalNumberLabel.anchorPoint = CGPointMake(1.0f, 1.0f);
    decimalNumberLabel.position = CGPointMake(screenSize.width*0.34, screenSize.height*0.96);
    decimalNumberLabel.color = ccBLACK;
    [self addChild:decimalNumberLabel z:-1 tag:6];
    
    //label for Score
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
    scoreLabel.anchorPoint = CGPointMake(1.0f, 1.0f);
    scoreLabel.position = CGPointMake(screenSize.width*0.97, screenSize.height*0.96);
    scoreLabel.color = ccBLACK;
    [self addChild:scoreLabel z:-1 tag:7];
    
    //label for Target Number        
    targetLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",targetNumber] fontName:@"Arial" fontSize:24];
    targetLabel.anchorPoint = CGPointMake(1.0f, 1.0f);
    targetLabel.position = CGPointMake(screenSize.width*0.67, screenSize.height*0.12);
    targetLabel.color = ccBLACK;
    [self addChild:targetLabel z:-1 tag:8];
    
    
    //label for time
    timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",time] fontName:@"TimesNewRomanPS-BoldMT" fontSize:21];
    timeLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
    timeLabel.position = CGPointMake(screenSize.width/2, screenSize.height*0.96 - 1);
    timeLabel.color = ccYELLOW;
    [self addChild:timeLabel z:-1 tag:9];
    
    // label for high score
    highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %i", [delegate getBinaryHighScore]] fontName:@"Marker Felt" fontSize:24];
    highScoreLabel.anchorPoint = CGPointMake(1.0f, 1.0f);
    highScoreLabel.position = CGPointMake(screenSize.width*0.97, screenSize.height*0.84);
    highScoreLabel.color = ccWHITE;
    [self addChild:highScoreLabel z:-1 tag:10];
    
}

-(void)initSwitches
{    
    //initialize an array of switches
    switches = [[CCArray alloc] initWithCapacity:numberOfBits];
    for (int i=0; i<numberOfBits; i++) {
        CCSprite* e_switch = [Switch spriteWithFile:@"switch00v8.png"];
        [self addChild:e_switch z:1 tag:FIRST_BIT];
        [switches addObject:e_switch];
    }
}

-(void)drawSwitchesWithScreenSize {
    
    CGFloat height;
    height = (screenSize.height+1);
    if (numberOfBits<=5) {
        for (int i=0; i<numberOfBits; i++) {
            CCSprite* temp = [switches objectAtIndex:i];
            if(numberOfBits ==5)
                temp.position = CGPointMake(screenSize.width/6+(int)(switchImageWidth*i*1.3), screenSize.height/2);
            else
                temp.position = CGPointMake(screenSize.width/numberOfBits+(int)(switchImageWidth*i*1.3), screenSize.height/2);
        }
    }
    else
    {
        for (int i=0; i<5; i++) {
            CCSprite* temp = [switches objectAtIndex:i];
            temp.position = CGPointMake(screenSize.width/6+(int)(switchImageWidth*i*1.3), height*17/27);
        }
        for (int i=5; i<numberOfBits; i++) {
            CCSprite* temp = [switches objectAtIndex:i];
            temp.position = CGPointMake(screenSize.width/6+(int)(switchImageWidth*(i-5)*1.3), height*10/27);
        }
    }
}

-(int)whatSwitchwithLocation:(CGPoint)touchLocation {
   
    /* 
     * find out if the touch is in the bounding box 
     * and find to what switch it is elong to
     */
    CGPoint touch;
    touch.x = touchLocation.x;
    touch.y = screenSize.height - touchLocation.y;
    
    for (int i=0; i<numberOfBits; i++) {
        CCNode* node = [switches objectAtIndex:i];
        BOOL m = CGRectContainsPoint([node boundingBox], touch);
        if (m) {
            return i;
        }
    }
    return -1;
}

-(void)checkWin {
    
    //check the winner by comparig the current number with target
    if (currentNumber == targetNumber) {
        currentScore = currentScore + numberOfBits;
        targetNumber = arc4random()%max;
        targetNumber ++;
        [self resetBitsandCurrent];
        [self updateLabels];
    }
}

-(void)resetBitsandCurrent {
    currentNumber = 0;
    for (int i = 0; i < numberOfBits; i++){
        Switch* tempSwitch = [switches objectAtIndex:i];
        if (switch_state[i]) {
            [self burstOnSwitch:tempSwitch];
        }
        [tempSwitch resetSwitch];
        switch_state[i]=0;
        //CCLabelTTF* temp = [numbersInBinary objectAtIndex:i];
        //[temp setString:[NSString stringWithFormat:@"%d",switch_state[i]]];
    }
}

- (void)burstOnSwitch:(Switch *)sender
{
    CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"explosion.plist"];
    particle.position = CGPointMake(sender.position.x, sender.position.y);
    [self addChild:particle z:20 tag:PARTICLES];
}
 
-(void)updateLabels {
    [decimalNumberLabel setString:[NSString stringWithFormat:@"%d",currentNumber]];
    [targetLabel setString:[NSString stringWithFormat:@"%d",targetNumber]];
    [scoreLabel setString:[NSString stringWithFormat:@"%d",currentScore]];
    if (currentScore > [delegate getBinaryHighScore]){
        [highScoreLabel setString:[NSString stringWithFormat:@"High Score: %i", currentScore]];
        [delegate binaryFinishedWithScore:currentScore];
    }
}

/*-(void)initBinaryCodes {
    numbersInBinary = [[CCArray alloc] initWithCapacity:numberOfBits];
    for (int i = 0; i < numberOfBits; i++)
	{
		CCLabelTTF* tempfont = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
		[self addChild:tempfont z:0 tag:2];
		[numbersInBinary addObject:tempfont];
	}
}

-(void)drawBinaryDigitsWithScreenSize {
    if (numberOfBits<=5) {
        for (int i=0; i<numberOfBits; i++) {
            CCLabelTTF* temp = [numbersInBinary objectAtIndex:i];
            if(numberOfBits ==5)
                temp.position = CGPointMake(screenSize.width/6+switchImageWidth*i*1.3, screenSize.height/3);
            else
                temp.position = CGPointMake(screenSize.width/numberOfBits+switchImageWidth*i*1.3, screenSize.height/3);
        }
    }
    else
    {
        for (int i=0; i<5; i++) {
            CCLabelTTF* temp = [numbersInBinary objectAtIndex:i];
            temp.position = CGPointMake(screenSize.width/6+switchImageWidth*i*1.3, screenSize.height/2);
        }
        for (int i=5; i<numberOfBits; i++) {
            CCLabelTTF* temp = [numbersInBinary objectAtIndex:i];
            temp.position = CGPointMake(screenSize.width/6+switchImageWidth*(i-5)*1.3, screenSize.height/6);
        }
    }
}*/

-(void)registerWithTouchDispatcher
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
    //CCLabelTTF* temp = [numbersInBinary objectAtIndex:switchNumber];
    //[temp setString:[NSString stringWithFormat:@"%d",switch_state[switchNumber]]];
}

-(void)updateBinaryNumber
{
    //find the number in binary, just for test
    int i=0,n=numberOfBits;
    numberInBinary = 0;
    while (n>0) {
        numberInBinary = numberInBinary + pow(10, n-1)*switch_state[i];
        n--;
        i++;
    }
}

-(void)updateDecimalNumber
{    
    //find the number in decimal
    int i=0,n=numberOfBits;
    numberInDecimal = 0;
    while (n>0) {
        numberInDecimal = numberInDecimal + pow(2, n-1)*switch_state[i];
        n--;
        i++;
    }
    currentNumber = numberInDecimal;
}

-(void) changeSwitchImageState:(int)number
{
    Switch* temp = [switches objectAtIndex:number];
    [temp isTapped];
}
/**
 * this function get a number in one base and change it to the number in output base 
 **/
-(NSString *)changeBaseFrom:(NSString *)iNumber base:(int)iBase to:(int)outputBase {
    int inputNumber = [iNumber integerValue];
    int decimalNumber = 0;
    int numberOfDigits = [iNumber length];
    NSNumber *t; 
    unichar m;
    int digit;
    int outputNumber = 0;
    int i=0, n = numberOfDigits;
    BOOL hex = NO;
    
    /*
     * change the number from iBase(inputBase
     * to number in decimal
     */
    
    if (iBase != 10) {
        while (n>0) {
            m = [iNumber characterAtIndex:i];
            t = [NSNumber numberWithUnsignedChar:m];
            digit = [t integerValue];
            if(digit > 60)
                digit = digit - 55;
            else
                digit = digit - 48;
            decimalNumber = decimalNumber + pow(iBase, n-1)*digit;
            n--;
            i++;
        }
    }
    else 
        decimalNumber = inputNumber;

    CCLOG(@"\n\n\n\n\nThe input number is %d\n\n\n", decimalNumber);    
    
    int rem, quotient;
    char charDigit;
    NSMutableString *outputString = [NSMutableString stringWithString:@""];
    int tempQuotient;
    
    /*
     * change the number from iBase(inputBase
     * to number in decimal
     */
    i = 0;
    if (outputBase != 10 && outputBase != 16) {
        do {
            rem = decimalNumber % outputBase;
            quotient = decimalNumber / outputBase;
            outputNumber = outputNumber + rem * pow(10, i);
            i++;
            if(quotient<outputBase)
                outputNumber = outputNumber + quotient * pow(10, i);
            else
                decimalNumber = quotient;
        } while(quotient >= outputBase);
    }
    else if(outputBase == 16) {
        hex = YES;
        quotient = decimalNumber / outputBase;
        do {
            rem = decimalNumber % outputBase;
            if (rem>=10){
                rem=rem+55;
            }
            else
                rem = rem + 48;
            charDigit = (char)rem;
            [outputString setString:[NSString stringWithFormat:@"%c%@",charDigit,outputString]];
            quotient = decimalNumber / outputBase;
            i++;
            if(quotient<outputBase){
                if(quotient>=10)
                    tempQuotient = quotient + 55;
                else
                    tempQuotient = quotient + 48;
                charDigit = (char)tempQuotient;
                [outputString setString:[NSString stringWithFormat:@"%c%@",charDigit,outputString]];
            }
            else
                decimalNumber = quotient;
        } while (quotient >= outputBase); 
    }
    else
        outputNumber = decimalNumber;
    if(!hex)
        outputString = [NSString stringWithFormat:@"%d", outputNumber];
    CCLOG(@"\n\n\n\n\nThe output number is %@\n\n\n", outputString);
    return outputString;
}

-(BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{    
    if (isPaused) {
        return NO;
    }
    //find the location of touch in here
    CGPoint touchLocation = [touch locationInView: [touch view]];

    //check the location of touch to see if the user touched
    //one of the switches
    int check = [self whatSwitchwithLocation:touchLocation];
    if (check == -1) {
        return NO;
    }
    
    //change the digit for the touched number
    [self changeSwitchState:check];
    [self changeSwitchImageState:check];
    
    //update binary and decimal number and labels
    [self updateBinaryNumber];
    [self updateDecimalNumber];
    [self updateLabels];
    
    //check for winning
    [self checkWin];
    
    return YES;
}

-(void)pauseGame 
{
    if (isPaused) {
        return;
    }
    CCMenuItemSprite *resumeButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"resumepv1.png"]
                                                             selectedSprite:NULL target:self 
                                                                   selector:@selector(resumeGame)];
    CCMenuItemSprite *mainButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"mmpbuttonv1.png"] 
                                                           selectedSprite:NULL target:self 
                                                                 selector:@selector(mainMenu)];
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:resumeButton, mainButton, nil];
    [menu alignItemsHorizontallyWithPadding:114];
    NSString *pauseBackground = [NSString stringWithFormat:@"pmenuv2.png"];
    PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:menu background:pauseBackground];
    [self addChild:pop z:1000];
    pauseButton.visible = NO;
    [self unschedule:@selector(countDown:)];
    isPaused = YES;
}

-(void)gameOver
{
    [delegate binaryFinishedWithScore:currentScore];
    [self unscheduleAllSelectors];
    CCMenuItemSprite *playAgainButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"goretryv1.png"] 
                                                                selectedSprite:NULL target:self 
                                                                      selector:@selector(playAgain)];
    CCMenuItemSprite *mainButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"gommv1.png"] 
                                                           selectedSprite:NULL target:self 
                                                                 selector:@selector(mainMenu)];
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:playAgainButton, mainButton, nil];
    [menu alignItemsHorizontallyWithPadding:250];
    NSString *pauseBackground = [NSString stringWithFormat:@"gomenubgv1.png"];
    PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:menu background:pauseBackground];
    [self addChild:pop z:1000];
}

-(void)playAgain
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[[self class] sceneWithNumberOfBits:numberOfBits]];
}

-(void)resumeGame
{
    pauseButton.visible = YES;
    [self schedule:@selector(countDown:) interval:1.0f];
    isPaused = NO;
}

-(void)mainMenu
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}

-(void)dealloc
{
    //CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self); 
    // never forget to call [super dealloc] 
    [switches release];
    //[numbersInBinary release];
    [super dealloc]; 
} 

@end

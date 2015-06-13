//
//  baseChanger.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseChanger.h"
#import "CCUIViewWrapper.h"
#import "AppDelegate.h"
#import "constant.h"
#import "unistd.h"
#import "MainMenu.h"

@interface BaseChanger (PublicMethods)
- (id)initWithBase:(int)inputBase toBase:(int)targetBase withTiming:(BOOL)havetiming;
- (NSString *)changeBaseFrom:(NSString *)iNumber base:(int)iBase to:(int)outputBase;
- (void)initializeArrayWithTargetBase:(int)target;
- (void)initializeButtonandLabels;
- (void)drawDigitLabels;
- (void)initializaDataPicker;
- (long)findMaxInBase:(int)base withThisManyDigit:(int)NoOfDigits;
- (void)initializeTarget;
- (void)resetTarget;
- (void)restartAfterWin;
- (void)burstAfterWin;
- (void)gameOver;
- (void)playAgain;
- (void)mainMenu;
@end


@implementation BaseChanger
+(id) sceneWithBase:(int)inputBase toBase:(int)targetBase withTiming:(BOOL)havetiming{
    
	CCScene *scene = [CCScene node];
	
	BaseChanger *layer = [[[BaseChanger alloc] initWithBase:inputBase toBase:targetBase  withTiming:havetiming] autorelease];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
    
	return scene;
} 

-(void)buttonPressed
{
    digitPicker.hidden = !(digitPicker.hidden);
    if (timing && activateTiming) {
        [self schedule:@selector(countDown:) interval:1.0f];          /* function for timer */
        activateTiming = NO;
    }
    start.hidden = YES;
    isGameStarted = YES;
}
- (void)resetPicker{
    for (int i=0; i < 8; i++) {
        [digitPicker selectRow:0 inComponent:i animated:YES];
    }
}
- (void)resetDigitLabel{
    for (int i=0; i < 8; i++) {
        [[digit_labels objectAtIndex:i] setText:@" 0"];
    }
}
- (void)returnButtonPressed
{
    [self unschedule:@selector(countDown:)];
    
    pauseView = [[[UIView alloc] initWithFrame:CGRectMake(-79, 80, screenSize.width, screenSize.height)] autorelease];
    pauseView.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    pauseView.backgroundColor = [UIColor redColor];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"pmenuv2.png"]];
    pauseView.backgroundColor = background;
    [background release];
    
    [myView addSubview:pauseView];
    
    
    
    UIButton *playAgainButton = [[[UIButton alloc] initWithFrame:CGRectMake(56, 97, 128, 128)] autorelease];
    UIColor *background1 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"resumepv1.png"]];
    playAgainButton.backgroundColor = background1;
    [background1 release];
    [playAgainButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchDown];
    [playAgainButton setEnabled:YES];
    [pauseView addSubview:playAgainButton];
    
    
    
    UIButton *mainMenuButton = [[[UIButton alloc] initWithFrame:CGRectMake(296, 97, 128, 128)] autorelease];
    UIColor *background2 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"mmpbuttonv1.png"]];
    mainMenuButton.backgroundColor = background2;
    [background2 release];
    [mainMenuButton addTarget:self action:@selector(mainMenu) forControlEvents:UIControlEventTouchDown];
    [mainMenuButton setEnabled:YES];
    [pauseView addSubview:mainMenuButton];
    
    
}

- (long)findMaxInBase:(int)base withThisManyDigit:(int)NoOfDigits{
    
    NSMutableString *tempString;
    tempString = [[[NSMutableString alloc] init] autorelease];
    [tempString setString:@""];
    char charDigit;
    int rem;
    for (int i=0; i<NoOfDigits; i++) {
        rem = base - 1;
        if (rem>=10)
            rem=rem+55;
        else
            rem = rem + 48;
        charDigit = (char)rem;
        [tempString setString:[NSString stringWithFormat:@"%@%c",tempString,charDigit]];
    }
    NSString *decimalNumber = [self changeBaseFrom:tempString base:base to:10];
    long output;
    output = (long)[decimalNumber integerValue];
    return output;
}
-(void)initializeTarget{
    
    /*
     * find the maximum number in both bases
     * and find the minimum one to begin with
     */
    int minBase = (newBase < oldBase) ? newBase : oldBase;
    maxTarget = [self findMaxInBase:minBase withThisManyDigit:8];
    maxNumber = maxTarget;
    CCLOG(@"\nmax is %ld\n",maxNumber);
    decimalTarget = arc4random()%maxNumber;
    decimalTarget ++;
    [stringDecimalTarget setString:[NSMutableString stringWithFormat:@"%ld",decimalTarget]];
    [stringTarget setString:[self changeBaseFrom:stringDecimalTarget base:10 to:oldBase]];    
}

-(id)initWithBase:(int)inputBase toBase:(int)targetBase withTiming:(BOOL)havetiming{
    if ((self = [super init])) 
    {
        //delegate for the game
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        screenSize = [[CCDirector sharedDirector] winSize];
        time = 100;
        timing = havetiming;
        activateTiming = (timing) ? YES : NO;
        isGameStarted = NO;
        
        //target Base and input base
        newBase = targetBase;
        oldBase = inputBase;
        stringTarget = [[NSMutableString alloc] init];
        stringCurrent = [[NSMutableString alloc] init];
        stringDecimalTarget = [[NSMutableString alloc] init];
        currentScore = 0;
        
        //initialize numbers 
        [self initializeTarget];
        
        //initialize main view
        myView	= [[UIView alloc] init];        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcmenuv1.png"]];
        myView.backgroundColor = background;
        [background release];
        
        
        //define and initialize the pickerView
        [self initializaDataPicker];    
        [self initializeArrayWithTargetBase:newBase];
        [self initializeButtonandLabels];
        [self drawDigitLabels];
        
        /*
         * initialize the wrapper for using 
         * UI objects in cocos2D
         */
        CCUIViewWrapper *wrapper = [CCUIViewWrapper wrapperForUIView:myView];
        CGSize temp;
        temp.width = screenSize.height;
        temp.height = screenSize.width;
        wrapper.contentSize = temp;
        
        //add subviews to the main view
        [myView addSubview:scoreLabel];
        [myView addSubview:highScoreLabel];
        [myView addSubview:targetLabel];
        [myView addSubview:currentLabel];
        if (timing)
            [myView addSubview:timeLabel];
        [myView addSubview:start];
        [myView addSubview:returnButton];
        [myView addSubview:digitPicker];
        [self addChild:wrapper];
    }
    return self;
}
- (void)initializaDataPicker {
    
    digitPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    digitPicker.delegate = self;
    digitPicker.dataSource = self;
    digitPicker.showsSelectionIndicator = NO;
    
    //make the rotation and transformation for dataPicker
    CGAffineTransform rotate = CGAffineTransformMakeRotation((90/180.0)*M_PI);  
    rotate = CGAffineTransformScale(rotate, 1, 1);
    CGAffineTransform t0 = CGAffineTransformMakeTranslation(UIPickerWidthTranslation*screenSize.height, UIPickerHeightTranslation*screenSize.width);
    digitPicker.transform = CGAffineTransformConcat(rotate,t0);
    digitPicker.hidden = YES;
    
    
}
-(void)countDown:(ccTime)delta
{
    time--;
    [timeLabel setText:[NSString stringWithFormat:@"%d",time]];
    if (time <= 0){
        
        [self unschedule:@selector(countDown:)];
        //when the time finishes
        [self gameOver];
    }
}
- (void)initializeArrayWithTargetBase:(int)target {
    
    //initialize the array for digits in UIPicker
    int rem;
    char charDigit;
    NSMutableString *stringForDigits;
    NSMutableArray *arrayForDigits;
    stringForDigits = [[[NSMutableString alloc] init] autorelease];
    arrayForDigits = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<target; i++) {
        rem = i;
        if (rem>=10)
            rem=rem+55;
        else
            rem = rem + 48;
        charDigit = (char)rem;
        stringForDigits = [NSString stringWithFormat:@"%c",charDigit];
        [arrayForDigits addObject:stringForDigits];
    }
    _digits = [[NSArray alloc] initWithArray:arrayForDigits];    
}
- (void)initializeButtonandLabels {
    
    CGRect frame;
    
    //initialize start button
    start = [[UIButton alloc] init];
    frame.size = CGSizeMake(40, 70);
    frame.origin = CGPointMake((screenSize.height-frame.size.width), (screenSize.width - frame.size.height)/2);
    start.frame = frame;
    
    /*
     * this three lines below
     * make the background for
     * the button
     */
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcstartv2.png"]];
    start.backgroundColor = background;
    [background release];
    
    [start addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
    [start setShowsTouchWhenHighlighted:YES];
    [start setEnabled:YES];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    //initializing return button
    returnButton = [[UIButton alloc] init];
    frame.size = CGSizeMake(40, 70);
    frame.origin = CGPointMake(screenSize.height - frame.size.width, 10);
    returnButton.frame = frame;
    UIColor *background1 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcmainv1"]];
    returnButton.backgroundColor = background1;
    [background1 release];
    [returnButton addTarget:self action:@selector(returnButtonPressed) forControlEvents:UIControlEventTouchDown];
    [returnButton setShowsTouchWhenHighlighted:YES];
    [returnButton setEnabled:YES];
    
    
    
    //initialize time label:
    timeLabel = [[UILabel alloc] init];
    frame.size = CGSizeMake(40, 70);
    [timeLabel setTextAlignment:UITextAlignmentCenter];
    [timeLabel setText:[NSString stringWithFormat:@"%d",time]];
    [timeLabel setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:21]];
    timeLabel.textColor = [UIColor yellowColor];
    frame.origin = CGPointMake((screenSize.height-frame.size.width), (screenSize.width - frame.size.height)/2);
    timeLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    timeLabel.frame = frame;
    UIColor *background2 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bctimev1.png"]];
    timeLabel.backgroundColor = background2;
    [background2 release];
    
    
    
    //score Label:
    scoreLabel = [[UILabel alloc] init];
    frame.size = CGSizeMake(40, 179);
    [scoreLabel setText:[NSString stringWithFormat:@"%d  ",currentScore]];
    [scoreLabel setTextAlignment:UITextAlignmentRight];
    frame.origin = CGPointMake(screenSize.height - frame.size.width  - 2, screenSize.width - frame.size.height - 2);
    scoreLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    scoreLabel.frame = frame;
    UIColor *background3 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcscorev3.png"]];
    scoreLabel.backgroundColor = background3;
    [background3 release];
    
    
    
    //target label
    frame.size = CGSizeMake(40, 179);
    targetLabel = [[UILabel alloc] init];
    [targetLabel setText:[NSString stringWithFormat:@"%@  ",stringTarget]];
    [targetLabel setTextAlignment:UITextAlignmentRight];
    frame.origin = CGPointMake(screenSize.height - 2*frame.size.width, 10);
    targetLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    targetLabel.frame = frame;
    UIColor *background4 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bctargetv3.png"]];
    targetLabel.backgroundColor = background4;
    [background4 release];
    
    
    
    //current label
    frame.size = CGSizeMake(40, 179);
    currentLabel = [[UILabel alloc] init];
    frame.origin = CGPointMake(screenSize.height - 3*frame.size.width , 10);
    currentLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    currentLabel.frame = frame;
    [currentLabel setText:@"0  "];
    [currentLabel setTextAlignment:UITextAlignmentRight];
    UIColor *background5 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bccurrentv3.png"]];
    currentLabel.backgroundColor = background5;
    [background5 release];
    
    
    // label for high score
    highScoreLabel = [[UILabel alloc] init]; 
    [highScoreLabel setFont:[UIFont fontWithName:@"Marker Felt" size:24]];
    [highScoreLabel setTextAlignment:UITextAlignmentRight];
    [highScoreLabel setText:[NSString stringWithFormat:@"High Score: %i ",[delegate getBaseChangerHighScore]]];
    [highScoreLabel setTextColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]];
    frame.size = CGSizeMake(40, 179);
    frame.origin = CGPointMake(screenSize.height - 2*frame.size.width  - 2, screenSize.width - frame.size.height - 2);
    highScoreLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    highScoreLabel.frame = frame;
    highScoreLabel.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0];
    
}
-(BOOL)checkWin {
    if ([stringTarget isEqualToString:stringCurrent]) {
        return YES;
    }
    return NO;
}
-(void)drawDigitLabels {
    
    CGRect frame;    
    float a = (screenSize.width - (2 * MARGIN_BASE_CHANGE + 1 + 7 * PIXELS_BETWEEN_IMAGES )) / 8;
    frame.size = CGSizeMake(32, a);
    digit_labels = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        UILabel* tempLabel = [[[UILabel alloc] init] autorelease];
        frame.origin = CGPointMake(screenSize.height/2, MARGIN_BASE_CHANGE + a*i + i*PIXELS_BETWEEN_IMAGES);
        tempLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
        tempLabel.frame = frame;
        [tempLabel setText:@""];
        
        //setting background for labels
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcnumv2.png"]];
        tempLabel.backgroundColor = background;
        [background release];
        
        [digit_labels insertObject:tempLabel atIndex:i];
        [tempLabel setFont:[UIFont fontWithName:@"Arial" size:24]];
        [myView addSubview:tempLabel];
    }
}
#pragma mark -
#pragma mark Picker Datasource Protocol 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    //return the number of columns in UIPickerView
    return 8;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent 
                       :(NSInteger)component {
    //return the number of rows in each columns
    switch (component) {
        case 0:
            return [_digits count];
            break;
        case 1:
            return [_digits count];
            break;
        case 2:
            return [_digits count];
            break;
        case 3:
            return [_digits count];
            break;
        case 4:
            return [_digits count];
            break;
        case 5:
            return [_digits count];
            break;
        case 6:
            return [_digits count];
            break;
        case 7:
            return [_digits count];
            break;
        default:
            return [_digits count];
            break;
    }
}
#pragma mark -
#pragma mark Picker Delegate Protocol
- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //return the selective object
    return [_digits objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    /*
     * This function changes 
     * the UIPicker, and also change the current
     * label and also check for
     * winning condition
     */
    
    
    NSMutableString* currentNumberString = [[[NSMutableString alloc] initWithString:@""] autorelease];
    for (int i=0; i < 8; i++) {
        [[digit_labels objectAtIndex:i] setText:[NSString stringWithFormat:@" %@",[_digits objectAtIndex:[digitPicker selectedRowInComponent:i]]]];
        [currentNumberString setString:[NSString stringWithFormat:@"%@%@",currentNumberString,[_digits objectAtIndex:[digitPicker selectedRowInComponent:i]]]];
    }
    NSString* output = [self changeBaseFrom:currentNumberString base:newBase to:oldBase];
    
    NSString* decimalOutput = [self changeBaseFrom:output base:oldBase to:10];
    [stringCurrent setString:output];
    if([decimalOutput integerValue] > maxNumber || [decimalOutput intValue] < 0)
        [currentLabel setText:@"Too BIGG!  "];
    else {
        [currentLabel setText:[NSString stringWithFormat:@"%@  ",output]];
    }
    if ([self checkWin]) {                                  /* if the player find the right number */
        currentScore += 10;
        usleep(500000);
        [self restartAfterWin];
    }
}
- (void)burstAfterWin //this function haven't been used yet
{
    CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"explosion.plist"];
    particle.position = CGPointMake(screenSize.height,screenSize.width);
    [self addChild:particle z:20];
}
-(void)restartAfterWin{
    
    /*
     * restart the labels and target
     */
    [scoreLabel setText:[NSString stringWithFormat:@"%d  ",currentScore]];
    [stringCurrent setString:@"0"];
    [currentLabel setText:[NSString stringWithFormat:@"%@  ",stringCurrent]];
    if (currentScore > [delegate getBaseChangerHighScore]) {
        [delegate baseChangerFinishedWithScore:currentScore];
        [highScoreLabel setText:[NSString stringWithFormat:@"High Score: %i ",currentScore]];
    }
    
    //resetUIPivker
    [self resetDigitLabel];
    [self resetPicker];
    [self resetTarget];
    [targetLabel setText:[NSString stringWithFormat:@"%@  ",stringTarget]];   
}
-(void)resetTarget
{
    decimalTarget = arc4random()%maxNumber;
    decimalTarget ++;
    [stringDecimalTarget setString:[NSMutableString stringWithFormat:@"%ld",decimalTarget]];
    [stringTarget setString:[self changeBaseFrom:stringDecimalTarget base:10 to:oldBase]];   
}


-(NSString *)changeBaseFrom:(NSString *)iNumber base:(int)iBase to:(int)outputBase {
    
    
    /* 
     * This function get a number string and chnages it
     * from old base to new base
     */
    
    long inputNumber = [iNumber integerValue];
    long decimalNumber = 0;
    int numberOfDigits = [iNumber length];
    NSNumber *t; 
    unichar m;
    int digit;
    long outputNumber = 0;
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
    
    int rem, quotient;
    char charDigit;
    NSMutableString *outputString = [NSMutableString stringWithString:@""];
    long tempQuotient;
    
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
    return outputString;
}

-(void)gameOver {
    
    [delegate baseChangerFinishedWithScore:currentScore];
    [self unscheduleAllSelectors];
    
    
    pauseView = [[[UIView alloc] initWithFrame:CGRectMake(-79, 80, screenSize.width, screenSize.height)] autorelease];
    pauseView.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    pauseView.backgroundColor = [UIColor redColor];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"gomenubgv1.png"]];
    pauseView.backgroundColor = background;
    [background release];
    
    [myView addSubview:pauseView];
    
    
    UIButton *playAgainButton = [[[UIButton alloc] initWithFrame:CGRectMake(350, 82, 100, 158)] autorelease];
    UIColor *background1 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"goretryv1.png"]];
    playAgainButton.backgroundColor = background1;
    [background1 release];
    [playAgainButton addTarget:self action:@selector(playAgain) forControlEvents:UIControlEventTouchDown];
    [playAgainButton setEnabled:YES];
    [pauseView addSubview:playAgainButton];
    
    
    
    UIButton *mainMenuButton = [[[UIButton alloc] initWithFrame:CGRectMake(30, 82, 100, 158)] autorelease];
    UIColor *background2 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"gommv1.png"]];
    mainMenuButton.backgroundColor = background2;
    [background2 release];
    [mainMenuButton addTarget:self action:@selector(mainMenu) forControlEvents:UIControlEventTouchDown];
    [mainMenuButton setEnabled:YES];
    [pauseView addSubview:mainMenuButton];
    
}
-(void)playAgain{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[[self class] sceneWithBase:oldBase toBase:newBase withTiming:YES]];
}

-(void)mainMenu {
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}
-(void)resumeGame {
    [pauseView removeFromSuperview];
    if(isGameStarted)
        [self schedule:@selector(countDown:) interval:1.0f];
}
-(void)dealloc {
    
    //releasing memory!
    
    [returnButton release];
    [timeLabel release];
    [digit_labels release];
    [stringTarget release];
    [stringDecimalTarget release];
    [stringCurrent release];
    [_digits release];
    [scoreLabel release];
    [highScoreLabel release];
    [targetLabel release];
    [currentLabel release];
    [myView release];
    [digitPicker release];
    [start release];
    [super dealloc];
}
@end

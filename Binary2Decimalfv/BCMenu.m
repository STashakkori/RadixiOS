//
//  BCMenu.m
//  Binary2Decimalfv
//
//  Created by Ahmad on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BCMenu.h"
#import "CCUIViewWrapper.h"
#import "constant.h"


@interface BCMenu (PublicMethods)
- (id)initWithTimingState:(BOOL)havetiming;
- (void)initializeArrayForBases;
- (void)initializeButtonandLabels;
//- (void)drawDigitLabels;
- (void)initializaDataPicker;
@end


@implementation BCMenu
+(id) sceneWithTimingState:(BOOL)havetiming{
    
	CCScene *scene = [CCScene node];
	BCMenu *layer = [[[BCMenu alloc] initWithTimingState:havetiming] autorelease];
	
	[scene addChild: layer];            /* add layer as a child to scene */
	return scene;
} 

-(void)buttonPressed
{
    if (newBase == oldBase) {
        
        start.enabled = NO;

        pauseView = [[[UIView alloc] initWithFrame:CGRectMake(25, 160, screenSize.width/2, screenSize.height/2)] autorelease];
        pauseView.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
        pauseView.backgroundColor = [UIColor redColor];
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"basemessagev1.png"]];
        pauseView.backgroundColor = background;
        [background release];
        
        [myView addSubview:pauseView];
        
        
        
        UIButton *playAgainButton = [[[UIButton alloc] initWithFrame:CGRectMake(screenSize.width/4 - 35, screenSize.height/2 - 60, 70, 40)] autorelease];
        [playAgainButton setTitle:@"" forState:UIControlStateNormal];
        //playAgainButton.backgroundColor = [UIColor greenColor];
        
        UIColor *background1 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"okv1.png"]];
        playAgainButton.backgroundColor = background1;
        [background1 release];
        
        [playAgainButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchDown];
        [playAgainButton setEnabled:YES];
        [pauseView addSubview:playAgainButton];
        
        
    }
    else
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[BaseChanger sceneWithBase:oldBase toBase:newBase withTiming:timing]]]; 
}
-(void)resumeGame {
    [pauseView removeFromSuperview];
    start.enabled = YES;
}

- (void)resetPicker{
    for (int i=0; i < 8; i++) {
        [digitPicker selectRow:0 inComponent:i animated:YES];
    }
}

-(id)initWithTimingState:(BOOL)havetiming{
    if ((self = [super init])) 
    {
        screenSize = [[CCDirector sharedDirector] winSize];
        
        newBase = 2;
        oldBase = 2;
        timing = havetiming;
        
        //initialize main view
        myView	= [[UIView alloc] init];
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcmenuv1.png"]];
        myView.backgroundColor = background;
        [background release];
        
        
        //define and initialize the pickerView
        [self initializaDataPicker];    
        [self initializeArrayForBases];
        [self initializeButtonandLabels];
        
        CCUIViewWrapper *wrapper = [CCUIViewWrapper wrapperForUIView:myView];
        
        CGSize temp;
        temp.width = screenSize.height;
        temp.height = screenSize.width;
        wrapper.contentSize = temp;
        [myView addSubview:start];
        [myView addSubview:ChangeFromLabel];
        [myView addSubview:ChangeToLabel];
        [myView addSubview:digitPicker];
        [self addChild:wrapper];
    }
    return self;
}
- (void)initializaDataPicker {
    CGRect frame;
    frame = CGRectMake(screenSize.width*1/5,screenSize.height*2/5,screenSize.width*3/5,screenSize.height*1/5);
    /*
     * change the size of UIDataPicker
     * the second(for being in the center
     * and forth parameters should be zero
     * fisrt one is the origin of it and 
     * third is the width
     */
    frame = CGRectMake(screenSize.height*13/20, 0, screenSize.width*4/10, 0);
    digitPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    digitPicker.delegate = self;
    digitPicker.dataSource = self;
    digitPicker.showsSelectionIndicator = NO;
    digitPicker.frame = frame;
    
    //make the rotation and transformation for dataPicker
    CGAffineTransform rotate = CGAffineTransformMakeRotation((90/180.0)*M_PI);  
    rotate = CGAffineTransformScale(rotate, 1, 1);
    CGAffineTransform t0 = CGAffineTransformMakeTranslation(UIPickerWidthTranslation*screenSize.height, UIPickerHeightTranslation*screenSize.width);
    digitPicker.transform = CGAffineTransformConcat(rotate,t0);
    digitPicker.hidden = NO;
    
}
- (void)initializeArrayForBases {
    
    //initialize the array for digits
    int rem;
    char charDigit;
    NSMutableString *stringForDigits;
    NSMutableArray *arrayForDigits;
    stringForDigits = [[[NSMutableString alloc] init] autorelease];
    arrayForDigits = [[[NSMutableArray alloc] init] autorelease];
    for (int i=2; i<10; i++) {
        rem = i;
        if (rem>=10)
            rem=rem+55;
        else
            rem = rem + 48;
        charDigit = (char)rem;
        stringForDigits = [NSString stringWithFormat:@"%c",charDigit];
        [arrayForDigits addObject:stringForDigits];
    }
    [arrayForDigits addObject:[NSString stringWithFormat:@"10"]];
    [arrayForDigits addObject:[NSString stringWithFormat:@"16"]];  
    
    _digits = [[NSArray alloc] initWithArray:arrayForDigits];    
}
- (void)initializeButtonandLabels {
    
    CGRect frame;
    
    
    start = [[UIButton alloc] init];
    frame.size = CGSizeMake(40, 70);
    frame.origin = CGPointMake((screenSize.height-frame.size.width), (screenSize.width - frame.size.height)/2);
    start.frame = frame;
    [start setBackgroundColor:[UIColor blueColor]];
    [start addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
    [start setShowsTouchWhenHighlighted:YES];
    [start setEnabled:YES];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcstartv2.png"]];
    start.backgroundColor = background;
    [background release];
    
    
    //ChangeFrom label
    frame.size = CGSizeMake(40, 120);
    ChangeFromLabel = [[UILabel alloc] init];
    [ChangeFromLabel setText:[NSString stringWithFormat:@"2 "]];
    [ChangeFromLabel setTextAlignment:UITextAlignmentRight];
    frame.origin = CGPointMake(screenSize.height - frame.size.width, 10);
    ChangeFromLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    ChangeFromLabel.frame = frame;
    UIColor *background1 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bcfromv1.png"]];
    ChangeFromLabel.backgroundColor = background1;
    [background1 release];
    
    //ChangeTo label
    ChangeToLabel = [[UILabel alloc] init];
    frame.origin = CGPointMake(screenSize.height - frame.size.width, screenSize.width - frame.size.height);
    ChangeToLabel.transform = CGAffineTransformMakeRotation((90/180.0)*M_PI);
    ChangeToLabel.frame = frame;
    [ChangeToLabel setText:@"2 "];
    [ChangeToLabel setTextAlignment:UITextAlignmentRight];
    UIColor *background2 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bctov1.png"]];
    ChangeToLabel.backgroundColor = background2;
    [background2 release];
    
}
#pragma mark -
#pragma mark Picker Datasource Protocol 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent 
                       :(NSInteger)component {
    switch (component) {
        case 0:
            return [_digits count];
            break;
        case 1:
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
    return [_digits objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    for (int i=0; i < 2; i++) {
        if (i==0) {
            [ChangeFromLabel setText:[NSString stringWithFormat:@"%d ",[[_digits objectAtIndex:[digitPicker selectedRowInComponent:i]] integerValue]]];
            oldBase = [[_digits objectAtIndex:[digitPicker selectedRowInComponent:i]] integerValue];
        }
        else if(i==1) {
            [ChangeToLabel setText:[NSString stringWithFormat:@"%d ",[[_digits objectAtIndex:[digitPicker selectedRowInComponent:i]] integerValue]]];
            newBase = [[_digits objectAtIndex:[digitPicker selectedRowInComponent:i]] integerValue];
        }
    }
}

-(void)dealloc {
    [_digits release];
    [ChangeFromLabel release];
    [ChangeToLabel release];
    [myView release];
    [digitPicker release];
    [start release];
    [super dealloc];
}
@end

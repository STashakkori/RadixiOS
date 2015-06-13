//
//  MainMenu.m
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"
#import "TwosComplement.h"
#import "AppDelegate.h"
#import "constant.h"
#import "PopUp.h"
#import "GameButton.h"
#import "CCMenuPopup.h"
#import "CCUIViewWrapper.h"

@implementation MainMenu

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        CGSize s = [[CCDirector sharedDirector] winSize];
        showHelp = NO;
        //BOOL isIPAD = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        
        //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CCSprite *bg = [CCSprite spriteWithFile:@"menubgv2.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg];
        
        //NSString *fileName = (isIPAD) ? [NSString stringWithFormat: @"%@-hd.plist", [delegate getCurrentSkin]] : [NSString stringWithFormat: @"%@.plist", [delegate getCurrentSkin]];
        
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileName];
        //int fSize = 24;
        //CCLabelTTF *highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %i", [delegate getHighScore]] fontName:@"TOONISH.ttf" fontSize:fSize];
        //highScore.anchorPoint = ccp(1,1);
        //highScore.position = ccp(s.width,s.height);
        //[self addChild:highScore];
        [CCMenuItemFont setFontName:@"Marker Felt"];
        int fSize = [CCMenuItemFont fontSize];
        [CCMenuItemFont setFontSize:48];
        isBinary = NO;
        isTwosComp = NO;
        play = [CCSprite spriteWithFile:@"mmswitch00v1.png"];
        CCMenuItemSprite *playButton = [CCMenuItemSprite itemFromNormalSprite:play selectedSprite:NULL target:self selector:@selector(playButtonTapped)];
        CCMenuItemSprite *helpButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"mmhelpv1.png"] selectedSprite:NULL target:self selector:@selector(showHelp)];
        CCMenuItemSprite *creditButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"mmcreditsv1.png"] selectedSprite:NULL target:self selector:@selector(showCredits)];
        CCMenuItemSprite *highScoreButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"mmhighv1.png"] selectedSprite:NULL target:self selector:@selector(showHighScore)];
        CCMenuItemSprite *transparentButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"transparent.png"] selectedSprite:NULL target:self selector:@selector(doNothing)];
        
        [CCMenuItemFont setFontSize:fSize/1.5];
        //CCMenuItemSprite *leaderboardsButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"Game Center"] selectedSprite:NULL target:self selector:@selector(showLeaderboard)];
        //CCMenuItemSprite *selectSkinButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"Skins"] selectedSprite:NULL target:self selector:@selector(selectSkin)];
        //CCMenuItemSprite *otherGamesButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"more games"] selectedSprite:NULL target:self selector:@selector(otherGames)];
        [CCMenuItemFont setFontSize:fSize];
        
        CCMenu *mainPlay = [CCMenu menuWithItems:playButton, nil];
        [mainPlay alignItemsHorizontally];
        [self addChild:mainPlay];
        
        //[menu alignItemsVertically];
        
        //menu.position = ccp(s.width, 20);
        
        CCMenu *secondaryMenu = [CCMenu menuWithItems:helpButton, creditButton, nil];
        [secondaryMenu alignItemsHorizontallyWithPadding:250];
        secondaryMenu.position = ccp(s.width/2, s.height/5);
        [self addChild:secondaryMenu];
        
        CCMenu *topMenu = [CCMenu menuWithItems:transparentButton, highScoreButton, nil];
        [topMenu alignItemsHorizontallyWithPadding:250];
        topMenu.position = ccp(s.width/2, s.height*4/5);
        [self addChild:topMenu];
        
        
        //fileName = (isIPAD) ? @"title_IPAD.png" : @"title.png";
        
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    }
    
    return self;
}

- (void)showHelp
{
    showHelp = YES;
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    UIView *help= [[[UIView alloc] initWithFrame:CGRectMake(-80, -400, size.width, size.height)] autorelease];
    help.backgroundColor = [UIColor grayColor];
    description = [[[UITextView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height-60)] autorelease];
    description.backgroundColor = [UIColor grayColor];
    description.text = [NSString stringWithString:@"For the standard unsigned and two's complement games, you have to match the target decimal number to its corresponding base-two bit pattern.  Depending on the number of chosen bits, the score will be accumulated, and if a high score is reached, it will be recorded.  If the user chooses a higher number of bits, then the number of points will increase.  Scoring is the same for both unsigned and two's complement games.\n\nFor more information on the binary numeral system, please refer to Wikipedia."];
    [description setEditable:NO]; 
    description.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
    description.showsHorizontalScrollIndicator = NO;
    description.showsVerticalScrollIndicator = YES;
    description.alwaysBounceVertical = YES;
    [help addSubview:description];
    
    
    UIButton *okButton = [[[UIButton alloc] initWithFrame:CGRectMake(size.width/2 -35,size.height-50, 70, 40)] autorelease];
    [okButton setTitle:@"" forState:UIControlStateNormal];
    //playAgainButton.backgroundColor = [UIColor greenColor];
    
    UIColor *background1 = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"okv1.png"]] autorelease];
    okButton.backgroundColor = background1;
    //[background1 release];
    
    [okButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchDown];
    [okButton setEnabled:YES];
    [help addSubview:okButton];
    
    
    CCUIViewWrapper *wrapper = [CCUIViewWrapper wrapperForUIView:help];
    //[description release];
    //[help release];
    [wrapper setRotation:90];
    //[okButton release];
   // CCSprite *container = [CCSprite node];
    [self addChild:wrapper z:10 tag:HELP_MENU];
    //PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:container background:@""];
    //[self addChild:pop z:1000 tag:HELP_MENU];
}
- (void) resumeGame{
    [self removeChildByTag:HELP_MENU cleanup:YES];
}

- (void)showCredits
{
    //CGSize s = [[CCDirector sharedDirector] winSize];
    CCMenuItemSprite *btnCancel = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"credbgv2.png"] selectedSprite:NULL];
    CCMenuPopup *cancelMenu = [CCMenuPopup menuWithItems:btnCancel, nil];
    //btnCancel.position = ccp(0,- s.height/3);
    [cancelMenu alignItemsHorizontally];
    CCSprite *container = [CCSprite node];
    [container addChild:cancelMenu];
    NSString *background = [NSString stringWithFormat:@"credbgv2.png"];
    PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:container background:background];
    [self addChild:pop z:1000];
}

- (void)showHighScore
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCMenuItemSprite *btnCancel = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"hsmenubgv1.png"] selectedSprite:NULL];
    CCMenuPopup *cancelMenu = [CCMenuPopup menuWithItems:btnCancel, nil];
    
    // binary high score label
    binaryHighScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", [delegate getBinaryHighScore]] fontName:@"Marker Felt" fontSize:24];
    binaryHighScoreLabel.anchorPoint = CGPointMake(1.0f, 1.0f);
    binaryHighScoreLabel.position = CGPointMake(screenSize.width*0.72, screenSize.height*0.68);
    binaryHighScoreLabel.color = ccWHITE;
    
    // two's complement high score label
    twosComplementHighScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", [delegate getTwosCompHighScore]] fontName:@"Marker Felt" fontSize:24];
    twosComplementHighScoreLabel.anchorPoint = CGPointMake(1.0f, 1.0f);
    twosComplementHighScoreLabel.position = CGPointMake(screenSize.width*0.72, screenSize.height*0.60);
    twosComplementHighScoreLabel.color = ccWHITE;
    
    // base changer high score label
    baseChangerHighScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", [delegate getBaseChangerHighScore]] fontName:@"Marker Felt" fontSize:24];
    baseChangerHighScoreLabel.anchorPoint = CGPointMake(1.0f, 1.0f);
    baseChangerHighScoreLabel.position = CGPointMake(screenSize.width*0.72, screenSize.height*0.52);
    baseChangerHighScoreLabel.color = ccWHITE;
    
    [cancelMenu alignItemsHorizontally];
    CCSprite *container = [CCSprite node];
    [container addChild:cancelMenu];
    [container addChild:binaryHighScoreLabel];
    [container addChild:twosComplementHighScoreLabel];
    [container addChild:baseChangerHighScoreLabel];
    NSString *background = [NSString stringWithFormat:@"credbgv2.png"];
    PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:container background:background];
    [self addChild:pop z:1000];
}

- (void)doNothing
{
    // nothing here but us chickens...
}

- (void)selectGame
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCMenuPopup *menu1 = [[[CCMenuPopup alloc] initWithItems:nil vaList:nil] autorelease];
    CCMenuPopup *menu2 = [[[CCMenuPopup alloc] initWithItems:nil vaList:nil] autorelease];
    CCMenuItemSprite *binaryGame = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"gmbinv1.png"] selectedSprite:NULL target:self selector:@selector(gameMultiplexer:)];
    CCMenuItemSprite *twosCompGame = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"gmtwosv1.png"] selectedSprite:NULL target:self selector:@selector(gameMultiplexer:)];
    CCMenuItemSprite *baseChangerGame = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"gmmultv1.png"] selectedSprite:NULL target:self selector:@selector(gameMultiplexer:)];
    [binaryGame setTag:BINARYGAME];
    [twosCompGame setTag:TWOSCOMPGAME];
    [baseChangerGame setTag:BASECHANGERGAME];
    
    //CCMenu *bottomMenu = [CCMenu menuWithItems:baseChangerGame, nil];
    [menu1 addChild:baseChangerGame];
    menu1.position = ccp(s.width/2, s.height/3);
    
    //CCMenu *topMenu = [CCMenu menuWithItems:binaryGame, twosCompGame, nil];
    [menu2 addChild:binaryGame];
    [menu2 addChild:twosCompGame];
    [menu2 alignItemsHorizontallyWithPadding:150];
    menu2.position = ccp(s.width/2, s.height*2/3);
    
    //CCMenuItemSprite *btnCancel = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"Cancel"] selectedSprite:NULL];
    
    //CCMenuPopup *cancelMenu = [CCMenuPopup menuWithItems:btnCancel, nil];
    //btnCancel.position = ccp(0,- s.height/3);
    CCSprite *container = [CCSprite node];
    [container addChild:menu2];
    [container addChild:menu1];
    //[container addChild:cancelMenu];
    NSString *background = [NSString stringWithFormat:@"gmenubgv1.png"];
    
    PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:container background:background];
    [self addChild:pop z:1000];
}

- (void)gameMultiplexer:(CCMenuItemImage *)sender
{
    int selector = sender.tag;
    switch (selector) {
        case BINARYGAME:
            isBinary = YES;
            [self selectBitLevel];
            break;
        case TWOSCOMPGAME:
            isTwosComp = YES;
            [self selectBitLevel];
            break;
        case BASECHANGERGAME:
            [self startBaseChanger];
            break;
        default:
            break;
    }
}

- (void)playButtonTapped
{
    [self stopAllActions];
    id playAction = [CCSequence actions:[CCDelayTime actionWithDuration:0.05], [CCAnimate actionWithAnimation:[self animationForwardWithFrames:0 to:2]], [CCCallFuncN actionWithTarget:self selector:@selector(selectGame)], nil];
    [play runAction:playAction];
}

- (void)selectBits:(CCMenuItemImage *)sender
{
    int tag = sender.tag;
    CCMenuPopup *menu = [[[CCMenuPopup alloc] initWithItems:nil vaList:nil] autorelease];
    //CGSize s = [[CCDirector sharedDirector] winSize];
    // even
    if (tag == EVEN) {
        for (int i = 2; i <= 10; i += 2) {
            CCMenuItemSprite *bitIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"menubutton-%d.png", i]] selectedSprite:NULL target:self selector:@selector(play:)];
            [bitIcon setTag:i];
            [menu addChild:bitIcon];
        }
    }
    // odd
    if (tag == ODD) {
        for (int i = 3; i <= 10; i += 2) {
            CCMenuItemSprite *bitIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"menubutton-%d.png", i]] selectedSprite:NULL target:self selector:@selector(play:)];
            [bitIcon setTag:i];
            [menu addChild:bitIcon];
        }
    }

    [menu alignItemsHorizontallyWithPadding:20];
    
    //CCMenuItemSprite *btnCancel = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"cancelv1.png"] selectedSprite:NULL];
    
    //CCMenuPopup *cancelMenu = [CCMenuPopup menuWithItems:btnCancel, nil];
    //btnCancel.position = ccp(0,- s.height/3);
    CCSprite *container = [CCSprite node];
    [container addChild:menu];
    //[container addChild:cancelMenu];
    NSString *background = [NSString stringWithFormat:@"smenubgv1.png"];
    
    PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:container background:background];
    [self addChild:pop z:1000];
}

- (void)selectBitLevel
{
    CCMenuPopup *menu = [[[CCMenuPopup alloc] initWithItems:nil vaList:nil] autorelease];
    CCMenuItemSprite *evenBits = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"evenbuttonv1.png"] selectedSprite:NULL target:self selector:@selector(selectBits:)];
    CCMenuItemSprite *oddBits = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"oddbuttonv1.png"] selectedSprite:NULL target:self selector:@selector(selectBits:)];
    [evenBits setTag:EVEN];
    [oddBits setTag:ODD];
    [menu addChild:evenBits];
    [menu addChild:oddBits];
    
    [menu alignItemsHorizontallyWithPadding:100];
    
    CCMenuItemSprite *btnCancel = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"cancelv1.png"] selectedSprite:NULL];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CCMenuPopup *cancelMenu = [CCMenuPopup menuWithItems:btnCancel, nil];
    btnCancel.position = ccp(0,- s.height/3);
    CCSprite *container = [CCSprite node];
    [container addChild:menu];
    [container addChild:cancelMenu];
    NSString *background = [NSString stringWithFormat:@"evenoddbgv1.png"];
    
    PopUp *pop = [PopUp popUpWithTitle:@"BIT PARITY" description:@"Select even or odd bits" sprite:container background:background];
    [self addChild:pop z:1000];
}

- (void)play:(CCMenuItemImage *)sender
{
    int bitnum = sender.tag;
    if (isBinary)
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[GameScene sceneWithNumberOfBits:bitnum]]];
    if (isTwosComp)
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[TwosComplement sceneWithNumberOfBits:bitnum]]];
}

- (void)startBaseChanger
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[BCMenu sceneWithTimingState:YES]]];
}

- (CCAnimation*)animationForwardWithFrames:(int)from to:(int)to
{
    CCAnimation *animation = [[[CCAnimation alloc] init] autorelease];
    for (int i = from; i <= to; i++) {
        [animation addFrameWithFilename:[NSString stringWithFormat:@"mmswitch0%iv1.png",i]];
    }
    [animation setDelay:0.085f];
    return animation;
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end

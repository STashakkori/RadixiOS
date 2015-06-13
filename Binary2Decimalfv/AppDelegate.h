//
//  AppDelegate.h
//  Binary2Decimalfv
//
//  Created by Ahmad on 2/12/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

- (void)binaryFinishedWithScore:(int)score;
- (int)getBinaryHighScore;
- (void)twosCompFinishedWithScore:(int)score;
- (int)getTwosCompHighScore;
- (void)baseChangerFinishedWithScore:(int)score;
- (int)getBaseChangerHighScore;

@end

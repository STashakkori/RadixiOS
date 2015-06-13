//
//  CCUIViewWrapper.h
//  Binary2Decimalfv
//
//  Created by Seth Hobson on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
//This classs will be used for adding UI kits

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite {
	UIView *uiItem;
	float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end
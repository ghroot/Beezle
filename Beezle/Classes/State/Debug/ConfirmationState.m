//
//  ConfirmationState.m
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmationState.h"
#import "Game.h"

@interface ConfirmationState()

-(void) createMenu;
-(void) confirm:(id)sender;
-(void) cancel:(id)sender;

@end

@implementation ConfirmationState

+(id) stateWithTitle:(NSString *)title block:(void (^)())block
{
	return [[[self alloc] initWithTitle:title block:block] autorelease];
}

-(id) initWithTitle:(NSString *)title block:(void (^)())block
{
	if (self = [super init])
	{
		_title = [title retain];
		_block = [block copy];
		
		[self createMenu];
	}
	return self;
}

-(void) dealloc
{
	[_title release];
	[_block release];
	
	[super dealloc];
}

-(void) createMenu
{
	_menu = [CCMenu menuWithItems:nil];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:_title fontName:@"Marker Felt" fontSize:26.0f];
	[titleLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[titleLabel setPosition:CGPointMake(winSize.width / 2, winSize.height - 40.0f)];
	[self addChild:titleLabel];
	
	CCMenuItemFont *yesMenuItem = [CCMenuItemFont itemWithString:@"Yes" target:self selector:@selector(confirm:)];
	[yesMenuItem setFontSize:40];
	[_menu addChild:yesMenuItem];
	CCMenuItemFont *noMenuItem = [CCMenuItemFont itemWithString:@"No" target:self selector:@selector(cancel:)];
	[noMenuItem setFontSize:60];
	[_menu addChild:noMenuItem];
	
	[_menu setPosition:ccpAdd([_menu position], CGPointMake(0.0f, -30.0f))];
	[_menu alignItemsVerticallyWithPadding:20.0f];
	
	[self addChild:_menu];
}

-(void) confirm:(id)sender
{
	_block();
	[_game popState];
}

-(void) cancel:(id)sender
{
	[_game popState];
}

@end

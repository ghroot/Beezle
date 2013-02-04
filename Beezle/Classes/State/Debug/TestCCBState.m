//
//  TestCCBState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TestCCBState.h"
#import "Game.h"
#import "CCBReader.h"

@interface TestCCBState()

-(NSString *) createString;
-(void) testLoadingFile:(NSString *)file lines:(NSMutableArray *)lines;

@end

@implementation TestCCBState

-(id) init
{
	if (self = [super init])
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGSize labelSize = CGSizeMake(winSize.width, winSize.height - 30.0f);
		_label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:14 dimensions:labelSize hAlignment:kCCTextAlignmentLeft];
		[_label setAnchorPoint:CGPointMake(0.0f, 1.0f)];
		[_label setPosition:CGPointMake(0.0f, winSize.height)];
		[self addChild:_label];

		CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
			[_game popState];
		}];
		[backMenuItem setAnchorPoint:CGPointZero];
		[backMenuItem setPosition:CGPointZero];
		[backMenuItem setFontSize:20];
		CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
		[backMenu setPosition:CGPointZero];
		[self addChild:backMenu];

		_needsLoadingState = TRUE;
	}
	return self;
}

-(void) initialise
{
	[super initialise];

	[_label setString:[self createString]];
}

-(NSString *) createString
{
	NSMutableArray *lines = [NSMutableArray array];

#ifdef LITE_VERSION
	[self testLoadingFile:@"GameCompletedLiteDialog.ccbi" lines:lines];
	[self testLoadingFile:@"LevelSelect-Lite.ccbi" lines:lines];
	[self testLoadingFile:@"ThemeSelectBuyFull.ccbi" lines:lines];
#else
	[self testLoadingFile:@"Credits.ccbi" lines:lines];
	[self testLoadingFile:@"GameAlmostCompletedDialog.ccbi" lines:lines];
	[self testLoadingFile:@"GameCompletedDialog.ccbi" lines:lines];
	[self testLoadingFile:@"HiddenLevelsFoundDialog.ccbi" lines:lines];
	[self testLoadingFile:@"LevelSelect.ccbi" lines:lines];
	[self testLoadingFile:@"ThemeSelect-B.ccbi" lines:lines];
	[self testLoadingFile:@"ThemeSelect-C.ccbi" lines:lines];
	[self testLoadingFile:@"ThemeSelect-D.ccbi" lines:lines];
	[self testLoadingFile:@"ThemeSelect-E.ccbi" lines:lines];
#endif
	[self testLoadingFile:@"LevelCompletedDialog.ccbi" lines:lines];
	[self testLoadingFile:@"LevelFailedDialog.ccbi" lines:lines];
	[self testLoadingFile:@"PausedDialog.ccbi" lines:lines];
	[self testLoadingFile:@"ThemeSelect-A.ccbi" lines:lines];

	NSMutableString *string = [NSMutableString string];
	if ([lines count] > 0)
	{
		for (NSString *line in lines)
		{
			[string appendFormat:@"%@\n", line];
		}
	}
	else
	{
		[string appendString:@"No errors found!\n"];
	}
	return string;
}

-(void) testLoadingFile:(NSString *)file lines:(NSMutableArray *)lines
{
	if ([CCBReader nodeGraphFromFile:file] == nil)
	{
		[lines addObject:[NSString stringWithFormat:@"Error loading file: %@", file]];
	}
}

@end

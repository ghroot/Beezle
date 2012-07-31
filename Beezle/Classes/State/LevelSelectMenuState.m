//
//  LevelSelectMenuState.m
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenuState.h"
#import "Game.h"
#import "GameplayState.h"
#import "CCBReader.h"

@interface LevelSelectMenuState()

-(void) startGame:(id)sender;
-(void) goBack:(id)sender;

@end

@implementation LevelSelectMenuState

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme
{
	return [[[self alloc] initWithTheme:theme] autorelease];
}

// Designated initialiser
-(id) initWithTheme:(NSString *)theme
{
    if (self = [super init])
    {
		_theme = [theme copy];
    }
    return self;
}

-(id) init
{
	return [self initWithTheme:nil];
}

-(void) initialise
{
	[super initialise];

	CCSprite *backgroundSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Colour-%@.jpg", _theme]];
	[backgroundSprite setAnchorPoint:CGPointMake(0.0f, 0.0f)];
	[self addChild:backgroundSprite];

	NSString *nodeFileName = [NSString stringWithFormat:@"LevelSelect-%@.ccbi", _theme];
	CCNode *node = [CCBReader nodeGraphFromFile:nodeFileName owner:self];
	for (CCNode *childNode in [node children])
	{
		if ([childNode isKindOfClass:[CCMenu class]])
		{
			for (CCNode *childNode2 in [childNode children])
			{
				if ([childNode2 isKindOfClass:[CCMenuItemImage class]])
				{
					NSString *levelString = [NSString stringWithFormat:@"%d", [childNode2 tag]];
					CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:levelString charMapFile:@"numberImages.png" itemWidth:30 itemHeight:30 startCharMap:'/'] autorelease];
					[label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
					[label setPosition:[childNode2 position]];
					[self addChild:label z:100];
				}
			}
		}
	}
	[self addChild:node];
}

-(void) dealloc
{
	[_theme release];
	
	[super dealloc];
}

-(void) startGame:(id)sender
{
	CCMenuItemImage *menuItem = (CCMenuItemImage *)sender;
	NSString *levelName = [NSString stringWithFormat:@"Level-%@%d", _theme, [menuItem tag]];
	[_game clearAndReplaceState:[GameplayState stateWithLevelName:levelName]];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end

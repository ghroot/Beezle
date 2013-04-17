//
// Created by Marcus on 17/04/2013.
//

#import "TestSlingerSpaceState.h"
#import "Game.h"
#import "LevelOrganizer.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"

static const int MIN_SPACE_HORIZONTAL = 60;
static const int MIN_SPACE_VERTICAL = 50;

@interface TestSlingerSpaceState()

-(NSString *) createString;

@end

@implementation TestSlingerSpaceState

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

	for (NSString *levelName in [[LevelOrganizer sharedOrganizer] allLevelNames])
	{
		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		for (LevelLayoutEntry *entry in [levelLayout entries])
		{
			if ([[entry type] isEqualToString:@"SLINGER"])
			{
				NSDictionary *transfomDict = [[entry instanceComponentsDict] objectForKey:@"transform"];
				CGPoint position = CGPointFromString([transfomDict objectForKey:@"position"]);
				if (position.x < MIN_SPACE_HORIZONTAL ||
						position.y > 320 - MIN_SPACE_VERTICAL)
				{
					[lines addObject:[NSString stringWithFormat:@"Slinger too close to edge in %@ (%f, %f)", levelName, position.x, position.y]];
				}
			}
		}
	}

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

@end
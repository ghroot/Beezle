//
//  EntityGroupSelectIngameMenuState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityGroupSelectIngameMenuState.h"
#import "Game.h"
#import "EntitySelectIngameMenuState.h"
#import "EntityGroupSelectMenuItem.h"

@interface EntityGroupSelectIngameMenuState()

-(void) createMenuItems;
-(void) addMenuItemForGroup:(NSString *)groupName andEntityTypes:(NSArray *)entityTypes;
-(void) gotoGroupMenu:(id)sender;
-(void) goBack:(id)sender;

@end

@implementation EntityGroupSelectIngameMenuState

-(id) init
{
	if (self = [super init])
	{
		_menu = [CCMenu menuWithItems:nil];

		[self createMenuItems];

		CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
		[backMenuItem setFontSize:26];
		[_menu addChild:backMenuItem];

		[_menu alignItemsVertically];

		[self addChild:_menu];
	}
	return self;
}

-(void) createMenuItems
{
	[self addMenuItemForGroup:@"Obstacles" andEntityTypes:[NSArray arrayWithObjects:
			@"BEEATER-BIRD",
			@"BEEATER-FISH",
			@"BEEATER-HANGING",
			@"BEEATER-LAND",
			@"CACTUS",
			@"CLIRR",
			@"HANGNEST",
			@"RAMP",
			@"SUPER-BEEATER",
			@"WOOD",
			@"WOOD-2",
			@"WOOD-3",
			@"WOOD-4",
			nil]];

	[self addMenuItemForGroup:@"Glass & Ice" andEntityTypes:[NSArray arrayWithObjects:
			@"GLASS",
			@"ICE",
			@"ICICLE",
			@"ICICLE-SMALL",
			nil]];

	[self addMenuItemForGroup:@"Tools" andEntityTypes:[NSArray arrayWithObjects:
			@"BRANCH",
			@"EGG",
			@"MUSHROOM",
			@"POLLEN-GREEN",
			@"POLLEN-ORANGE",
			@"POLLEN-YELLOW",
			@"SLINGER",
			@"SMOKE-MUSHROOM",
			nil]];

	[self addMenuItemForGroup:@"Particles" andEntityTypes:[NSArray arrayWithObjects:
			@"LAVA-ERUPTION",
			@"SMOKE",
			nil]];

	[self addMenuItemForGroup:@"Other" andEntityTypes:[NSArray arrayWithObjects:
			@"FLOATING-BLOCK-A",
			@"FROZEN-TBEE",
			@"LEAF",
			@"WATERDROP-SPAWNER",
			nil]];
}

-(void) addMenuItemForGroup:(NSString *)groupName andEntityTypes:(NSArray *)entityTypes
{
	EntityGroupSelectMenuItem *menuItem = [[[EntityGroupSelectMenuItem alloc] initWithGroupName:groupName andEntityTypes:entityTypes target:self selector:@selector(gotoGroupMenu:)] autorelease];
	[_menu addChild:menuItem];
}

-(void) gotoGroupMenu:(id)sender
{
	EntityGroupSelectMenuItem *menuItem = sender;

	[_game pushState:[[[EntitySelectIngameMenuState alloc] initWithEntityTypes:[menuItem entityTypes]] autorelease]];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end

//
//  EntitySelectIngameMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntitySelectIngameMenuState.h"
#import "EditState.h"
#import "Game.h"
#import "LevelOrganizer.h"

@interface EntitySelectIngameMenuState()

-(void) createEntityMenuItems;
-(void) addMenuItemForEntityType:(NSString *)entityType;

-(void) addEntity:(id)sender;

-(void) cancel:(id)sender;

@end

@implementation EntitySelectIngameMenuState

-(id) init
{
	if (self = [super init])
	{
		_menu = [CCMenu menuWithItems:nil];
		
		[self createEntityMenuItems];
		
		CCMenuItemFont *cancelMenuItem = [CCMenuItemFont itemWithString:@"<cancel>" target:self selector:@selector(cancel:)];
		[cancelMenuItem setFontSize:18];
		[_menu addChild:cancelMenuItem];
		
		int nMenuItems = [[_menu  children] count];
		int num1 = ceilf(nMenuItems / 3.0f);
		int num2 = nMenuItems - 2 * num1;
		[_menu alignItemsInRows:[NSNumber numberWithInt:num1], [NSNumber numberWithInt:num1], [NSNumber numberWithInt:num2], nil];
		
		[self addChild:_menu];
	}
    return self;
}

-(void) createEntityMenuItems
{
	[self addMenuItemForEntityType:@"BEEATER-LAND"];
	[self addMenuItemForEntityType:@"BEEATER-HANGING"];
	[self addMenuItemForEntityType:@"BEEATER-BIRD"];
	[self addMenuItemForEntityType:@"BEEATER-FISH"];
	[self addMenuItemForEntityType:@"CAVEGATE"];
	[self addMenuItemForEntityType:@"EGG"];
	[self addMenuItemForEntityType:@"FLOATING-BLOCK-A"];
	[self addMenuItemForEntityType:@"GLASS"];
	[self addMenuItemForEntityType:@"HANGNEST"];
	[self addMenuItemForEntityType:@"LEAF"];
	[self addMenuItemForEntityType:@"MUSHROOM"];
	[self addMenuItemForEntityType:@"NUT"];
	[self addMenuItemForEntityType:@"POLLEN"];
	[self addMenuItemForEntityType:@"POLLEN-ORANGE"];
	[self addMenuItemForEntityType:@"RAMP"];
	[self addMenuItemForEntityType:@"SLINGER"];
	[self addMenuItemForEntityType:@"SMOKE-MUSHROOM"];
	[self addMenuItemForEntityType:@"WOOD"];
	[self addMenuItemForEntityType:@"WOOD-2"];
	[self addMenuItemForEntityType:@"WOOD-3"];
	[self addMenuItemForEntityType:@"WOOD-4"];
	[self addMenuItemForEntityType:@"WATERDROP-SPAWNER"];
}

-(void) addMenuItemForEntityType:(NSString *)entityType
{
	CCMenuItemFont *menuItem = [CCMenuItemFont itemWithString:entityType target:self selector:@selector(addEntity:)];
	[menuItem setFontSize:20];
	[menuItem setUserData:entityType];
	[_menu addChild:menuItem];
}

-(void) addEntity:(id)sender
{
	CCMenuItem *menuItem = sender;
	NSString *entityType = [menuItem userData];
	
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	
	if ([entityType isEqualToString:@"BEEATER-LAND"] ||
		[entityType isEqualToString:@"BEEATER-HANGING"] ||
		[entityType isEqualToString:@"BEEATER-BIRD"] ||
		[entityType isEqualToString:@"BEEATER-FISH"] ||
		[entityType isEqualToString:@"HANGNEST"])
	{
		NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:[editState levelName]];
		entityType = [entityType stringByAppendingFormat:@"-%@", theme];
	}
	else if ([entityType isEqualToString:@"GLASS"])
	{
		NSString *levelSuffix = [[[editState levelName] componentsSeparatedByString:@"-"] objectAtIndex:1];
		if ([levelSuffix isEqualToString:@"B40"])
		{
			[editState addEntityWithType:@"GLASS-B40-1"];
			[editState addEntityWithType:@"GLASS-B40-2"];
			[editState addEntityWithType:@"GLASS-B40-3"];
			return;
		}
		else
		{
			entityType = [NSString stringWithFormat:@"GLASS-%@", levelSuffix];
		}
	}
	
	[editState addEntityWithType:entityType];
}

-(void) cancel:(id)sender
{
	[_game popState];
}

@end

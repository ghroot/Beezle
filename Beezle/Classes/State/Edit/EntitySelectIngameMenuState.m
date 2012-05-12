//
//  EntitySelectIngameMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntitySelectIngameMenuState.h"
#import "EditState.h"
#import "EntityFactory.h"
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
    [self addMenuItemForEntityType:@"SUPER-BEEATER"];
	[self addMenuItemForEntityType:@"CLIRR"];
	[self addMenuItemForEntityType:@"EGG"];
	[self addMenuItemForEntityType:@"FLOATING-BLOCK-A"];
	[self addMenuItemForEntityType:@"FROZEN-TBEE"];
	[self addMenuItemForEntityType:@"GLASS"];
	[self addMenuItemForEntityType:@"HANGNEST"];
	[self addMenuItemForEntityType:@"LEAF"];
	[self addMenuItemForEntityType:@"MUSHROOM"];
	[self addMenuItemForEntityType:@"POLLEN-YELLOW"];
	[self addMenuItemForEntityType:@"POLLEN-ORANGE"];
	[self addMenuItemForEntityType:@"POLLEN-GREEN"];
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
		[entityType isEqualToString:@"HANGNEST"] ||
		[entityType isEqualToString:@"RAMP"])
	{
		NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:[editState levelName]];
		entityType = [entityType stringByAppendingFormat:@"-%@", theme];
	}
	else if ([entityType isEqualToString:@"GLASS"])
	{
		NSString *levelSuffix = [[[editState levelName] componentsSeparatedByString:@"-"] objectAtIndex:1];
		NSString *glassEntityType = [NSString stringWithFormat:@"GLASS-%@", levelSuffix];
		if ([EntityFactory getEntityDescription:glassEntityType] != nil)
		{
			[editState addEntityWithType:glassEntityType];
		}
		else
		{
			int i = 1;
			while (TRUE)
			{
				NSString *glassEntityType = [NSString stringWithFormat:@"GLASS-%@-%d", levelSuffix, i++];
				if ([EntityFactory getEntityDescription:glassEntityType] != nil)
				{
					[editState addEntityWithType:glassEntityType];
				}
				else
				{
					break;
				}
			}
		}
		return;
	}
	else if ([entityType isEqualToString:@"CLIRR"])
	{
		int i = 1;
		while (TRUE)
		{
			NSString *clirrEntityType = [NSString stringWithFormat:@"CLIRR-C55-%d", i++];
			if ([EntityFactory getEntityDescription:clirrEntityType] != nil)
			{
				[editState addEntityWithType:clirrEntityType];
			}
			else
			{
				break;
			}
		}
		return;
	}
	
	[editState addEntityWithType:entityType];
}

-(void) cancel:(id)sender
{
	[_game popState];
}

@end

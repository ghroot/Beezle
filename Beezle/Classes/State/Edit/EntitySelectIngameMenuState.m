//
//  EntitySelectIngameMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntitySelectIngameMenuState.h"
#import "EditState.h"
#import "EntityDescription.h"
#import "EntityFactory.h"
#import "Game.h"
#import "LevelOrganizer.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "StringList.h"

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
	[self addMenuItemForEntityType:@"ICE"];
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
	
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:[editState levelName]];
	NSString *levelSuffix = [[[editState levelName] componentsSeparatedByString:@"-"] objectAtIndex:1];
	
	if ([entityType isEqualToString:@"BEEATER-LAND"] ||
		[entityType isEqualToString:@"BEEATER-HANGING"] ||
		[entityType isEqualToString:@"BEEATER-BIRD"] ||
		[entityType isEqualToString:@"BEEATER-FISH"] ||
		[entityType isEqualToString:@"HANGNEST"] ||
		[entityType isEqualToString:@"RAMP"])
	{
		entityType = [entityType stringByAppendingFormat:@"-%@", theme];
	}
	else if ([entityType isEqualToString:@"GLASS"])
	{
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
		EntityDescription *clirrEntityDescription = [EntityFactory getEntityDescription:@"CLIRR"];
		NSDictionary *clirrRenderComponentDict = [[clirrEntityDescription typeComponentsDict] objectForKey:@"render"];
		NSDictionary *clirrRenderSpriteDict = [[clirrRenderComponentDict objectForKey:@"sprites"] lastObject];
		NSString *clirrAnimationsFile = [clirrRenderSpriteDict objectForKey:@"animationFile"];
		NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:clirrAnimationsFile];
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
		NSDictionary *animationsDict = [dict objectForKey:@"animations"];
		NSMutableArray *clirrAnimationNames = [NSMutableArray array];
		for (NSString *animationName in [animationsDict allKeys])
		{
			[clirrAnimationNames addObject:animationName];
		}
		
		int i = 1;
		while (TRUE)
		{
			NSString *clirrAnimationName = [NSString stringWithFormat:@"%@-Clirr-%d", levelSuffix, i++];
			if ([clirrAnimationNames containsObject:clirrAnimationName])
			{
				Entity *clirrEntity = [editState addEntityWithType:@"CLIRR"];
				RenderComponent *clirrRenderComponent = [RenderComponent getFrom:clirrEntity];
				RenderSprite *clirrRenderSprite = [clirrRenderComponent defaultRenderSprite];
				[[clirrRenderSprite defaultIdleAnimationNames] addString:clirrAnimationName];
				[clirrRenderSprite playDefaultIdleAnimation];
			}
			else
			{
				i = 1;
				int j = 1;
				BOOL atLeastOneAnimationForThisI = FALSE;
				while (TRUE)
				{
					clirrAnimationName = [NSString stringWithFormat:@"%@-Clirr-%d-%d", levelSuffix, i, j++];
					if ([clirrAnimationNames containsObject:clirrAnimationName])
					{
						Entity *clirrEntity = [editState addEntityWithType:@"CLIRR"];
						RenderComponent *clirrRenderComponent = [RenderComponent getFrom:clirrEntity];
						RenderSprite *clirrRenderSprite = [clirrRenderComponent defaultRenderSprite];
						[[clirrRenderSprite overrideIdleAnimationNames] addString:clirrAnimationName];
						[clirrRenderSprite playDefaultIdleAnimation];
						
						atLeastOneAnimationForThisI = TRUE;
					}
					else
					{
						if (atLeastOneAnimationForThisI)
						{
							atLeastOneAnimationForThisI = FALSE;
							i++;
							j = 1;
						}
						else
						{
							break;
						}
					}
				}
				
				break;
			}
		}
		
		return;
	}
	else if ([entityType isEqualToString:@"ICE"])
	{
		NSString *iceEntityType = [NSString stringWithFormat:@"ICE-%@", levelSuffix];
		if ([EntityFactory getEntityDescription:iceEntityType] != nil)
		{
			[editState addEntityWithType:iceEntityType];
		}
		else
		{
			int i = 1;
			while (TRUE)
			{
				NSString *iceEntityType = [NSString stringWithFormat:@"ICE-%@-%d", levelSuffix, i++];
				if ([EntityFactory getEntityDescription:iceEntityType] != nil)
				{
					[editState addEntityWithType:iceEntityType];
				}
				else
				{
					break;
				}
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

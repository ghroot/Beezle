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
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
		_menu = [CCMenu menuWithItems:nil];
		
		[self createEntityMenuItems];
		
		CCMenuItemFont *cancelMenuItem = [CCMenuItemFont itemWithString:@"<cancel>" target:self selector:@selector(cancel:)];
		[cancelMenuItem setFontSize:18];
		[_menu addChild:cancelMenuItem];
		
		int nMenuItems = [[_menu  children] count];
		int num1 = ceilf(nMenuItems / 2.0f);
		int num2 = floorf(nMenuItems / 2.0f);
		[_menu alignItemsInRows:[NSNumber numberWithInt:num1], [NSNumber numberWithInt:num2], nil];
		
		[self addChild:_menu];
	}
    return self;
}

-(void) createEntityMenuItems
{
	[self addMenuItemForEntityType:@"BEEATER-BIRD"];
	[self addMenuItemForEntityType:@"BEEATER-CEILING"];
	[self addMenuItemForEntityType:@"BEEATER-FISH"];
	[self addMenuItemForEntityType:@"BEEATER"];
	[self addMenuItemForEntityType:@"CAVEGATE"];
	[self addMenuItemForEntityType:@"EGG"];
	[self addMenuItemForEntityType:@"FLOATING-BLOCK-A"];
	[self addMenuItemForEntityType:@"GLASS-A29"];
	[self addMenuItemForEntityType:@"GLASS-A34"];
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
	[sender setIsEnabled:FALSE];
	
	CCMenuItem *menuItem = sender;
	NSString *entityType = [menuItem userData];
	
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	[editState addEntityWithType:entityType];
}

-(void) cancel:(id)sender
{
	[sender setIsEnabled:FALSE];
	
	[_game popState];
}

@end

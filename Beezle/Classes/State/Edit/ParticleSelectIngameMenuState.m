//
//  ParticleSelectIngameMenuState.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/07/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticleSelectIngameMenuState.h"
#import "ParticleSelectMenuItem.h"
#import "Game.h"
#import "EditState.h"

@interface ParticleSelectIngameMenuState()

-(void) createParticleMenuItems:(NSArray *)particleNames;
-(void) addMenuItemForParticleName:(NSString *)particleName;
-(void) addParticleEntity:(id)sender;

@end

@implementation ParticleSelectIngameMenuState

-(id) initWithParticleNames:(NSArray *)particleNames
{
	if (self = [super init])
	{
		_menu = [CCMenu menuWithItems:nil];

		[self createParticleMenuItems:particleNames];

		CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
		[backMenuItem setFontSize:24];
		[_menu addChild:backMenuItem];

		int nMenuItems = [[_menu  children] count];
		int num1 = (int)ceilf(nMenuItems / 2.0f);
		int num2 = nMenuItems - num1;
		[_menu alignItemsInRows:[NSNumber numberWithInt:num1], [NSNumber numberWithInt:num2], nil];

		[self addChild:_menu];
	}
	return self;
}

-(void) createParticleMenuItems:(NSArray *)particleNames
{
	for (NSString *particleName in particleNames)
	{
		[self addMenuItemForParticleName:particleName];
	}
}

-(void) addMenuItemForParticleName:(NSString *)particleName
{
	ParticleSelectMenuItem *menuItem = [[[ParticleSelectMenuItem alloc] initWithParticleName:particleName target:self selector:@selector(addParticleEntity:)] autorelease];
	[menuItem setFontSize:26];
	[menuItem setUserData:particleName];
	[_menu addChild:menuItem];
}

-(void) addParticleEntity:(id)sender
{
	CCMenuItem *menuItem = sender;
	NSString *particleName = [menuItem userData];

	[_game popState];
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];

	NSString *particleFile = [NSString stringWithFormat:@"%@.plist", particleName];

	NSMutableDictionary *instanceComponentsDict = [NSMutableDictionary dictionary];

	NSMutableDictionary *renderInstanceComponentDict = [NSMutableDictionary dictionary];
	[renderInstanceComponentDict setObject:particleFile forKey:@"overrideParticleFile"];
	[instanceComponentsDict setObject:renderInstanceComponentDict forKey:@"render"];

	[editState addEntityWithType:@"PARTICLE" instanceComponentsDict:instanceComponentsDict];
}

@end

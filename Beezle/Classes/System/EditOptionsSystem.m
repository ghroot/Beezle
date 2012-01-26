//
//  EditRenderingSystem.m
//  Beezle
//
//  Created by Me on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditOptionsSystem.h"
#import "BeeQueueRenderingSystem.h"
#import "BeeaterComponent.h"
#import "BeeType.h"
#import "EditComponent.h"
#import "EditControlSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

@interface EditOptionsSystem()

-(void) createGeneralOptionsMenu;
-(void) createGeneralEntityOptionsMenu;
-(void) createBeeaterOptionsMenu;
-(void) createSlingerOptionsMenu;
-(CCMenuItem *) createMenuItem:(NSString *)label selector:(SEL)selector userData:(void *)userData;

@end

@implementation EditOptionsSystem

-(id) initWithLayer:(CCLayer *)layer
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[EditComponent class], nil]])
	{
		_layer = layer;
		
		[self createGeneralOptionsMenu];
		[self createGeneralEntityOptionsMenu];
		[self createBeeaterOptionsMenu];
		[self createSlingerOptionsMenu];
		[_layer addChild:_generalOptionsMenu];
	}
	return self;
}

-(void) dealloc
{
	[_generalOptionsMenu release];
	[_generalEntityOptionsMenu release];
	[_beeaterOptionsMenu release];
	[_slingerOptionsMenu release];
	
	[super dealloc];
}

-(void) createGeneralOptionsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	_generalOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_generalOptionsMenu setPosition:CGPointMake(winSize.width / 2, 14)];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Beeater" selector:@selector(doOptionAddEntity:) userData:@"BEEATER"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Mushroom" selector:@selector(doOptionAddEntity:) userData:@"MUSHROOM"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Nut" selector:@selector(doOptionAddEntity:) userData:@"NUT"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Pollen" selector:@selector(doOptionAddEntity:) userData:@"POLLEN"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Ramp" selector:@selector(doOptionAddEntity:) userData:@"RAMP"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Slinger" selector:@selector(doOptionAddEntity:) userData:@"SLINGER"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Wood" selector:@selector(doOptionAddEntity:) userData:@"WOOD"]];
	[_generalOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createGeneralEntityOptionsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	_generalEntityOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_generalEntityOptionsMenu setPosition:CGPointMake(winSize.width / 2, 14)];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Mirror" selector:@selector(doOptionMirror:) userData:nil]];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Rotate Left" selector:@selector(doOptionRotateLeft:) userData:nil]];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Rotate Right" selector:@selector(doOptionRotateRight:) userData:nil]];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Delete" selector:@selector(doOptionDelete:) userData:nil]];
	[_generalEntityOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createBeeaterOptionsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	_beeaterOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_beeaterOptionsMenu setPosition:CGPointMake(winSize.width / 2, 34)];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Bee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"BEE"]];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Bombee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"BOMBEE"]];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Speedee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"SPEEDEE"]];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Sawee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"SAWEE"]];
	[_beeaterOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createSlingerOptionsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	_slingerOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_slingerOptionsMenu setPosition:CGPointMake(winSize.width / 2, 34)];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Bee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"BEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Bombee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"BOMBEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Speedee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"SPEEDEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Sawee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"SAWEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Clear" selector:@selector(doOptionClearSlingerBees:) userData:nil]];	
	[_slingerOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(CCMenuItem *) createMenuItem:(NSString *)label selector:(SEL)selector userData:(void *)userData
{
	CCMenuItemFont *menuItem = [CCMenuItemFont itemFromString:label target:self selector:selector];
	[menuItem setFontSize:14];
	[menuItem setUserData:userData];
	return menuItem;
}

-(void) begin
{
	EditControlSystem *editControlSystem = (EditControlSystem *)[[_world systemManager] getSystem:[EditControlSystem class]];
	if (_entityWithOptionsDisplayed != [editControlSystem selectedEntity])
	{
		_entityWithOptionsDisplayed = [editControlSystem selectedEntity];
		if (_entityWithOptionsDisplayed != nil)
		{
			[_layer removeChild:_generalOptionsMenu cleanup:TRUE];
			[_layer addChild:_generalEntityOptionsMenu];
			if ([_entityWithOptionsDisplayed hasComponent:[BeeaterComponent class]])
			{
				[_layer addChild:_beeaterOptionsMenu];
			}
			if ([_entityWithOptionsDisplayed hasComponent:[SlingerComponent class]])
			{
				[_layer addChild:_slingerOptionsMenu];
			}
		}
		else
		{
			[_layer removeChild:_generalEntityOptionsMenu cleanup:TRUE];
			[_layer addChild:_generalOptionsMenu];
			[_layer removeChild:_beeaterOptionsMenu cleanup:TRUE];
			[_layer removeChild:_slingerOptionsMenu cleanup:TRUE];
		}
	}
}

-(void) doOptionAddEntity:(id)sender
{
	CCMenuItem *menuItem = (CCMenuItem *)sender;
	NSString *type = [menuItem userData];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	Entity *entity = nil;
	if ([type isEqualToString:@"POLLEN"])
	{
		entity = [EntityFactory createPollen:_world];
	}
	else if ([type isEqualToString:@"BEEATER"])
	{
		entity = [EntityFactory createBeeater:_world withBeeType:[BeeType enumFromName:@"BEE"]];
	}
	else if ([type isEqualToString:@"RAMP"])
	{
		entity = [EntityFactory createRamp:_world];
	}
	else if ([type isEqualToString:@"NUT"])
	{
		entity = [EntityFactory createNut:_world];
	}
	else if ([type isEqualToString:@"MUSHROOM"])
	{
		entity = [EntityFactory createMushroom:_world];
	}
	else if ([type isEqualToString:@"SLINGER"])
	{
		BOOL slingerExists = FALSE;
		for (Entity *entity in [[_world entityManager] entities])
		{
			if ([entity hasComponent:[SlingerComponent class]])
			{
				slingerExists = TRUE;
				break;
			}
		}
		if (!slingerExists)
		{
			entity = [EntityFactory createSlinger:_world withBeeTypes:[NSArray array]];
		}
	}
	else if ([type isEqualToString:@"WOOD"])
	{
		entity = [EntityFactory createWood:_world];
	}
	
	if (entity != nil)
	{
		[entity addComponent:[EditComponent componentWithLevelLayoutType:type]];
		[entity refresh];
		[EntityUtil setEntityPosition:entity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
	}
}

-(void) doOptionMirror:(id)sender
{
	TransformComponent *transformComponent = (TransformComponent *)[_entityWithOptionsDisplayed getComponent:[TransformComponent class]];
	[transformComponent setScale:CGPointMake(-[transformComponent scale].x, [transformComponent scale].y)];
}

-(void) doOptionRotateLeft:(id)sender
{
	TransformComponent *transformComponent = (TransformComponent *)[_entityWithOptionsDisplayed getComponent:[TransformComponent class]];
	float newAngle = [transformComponent rotation] - 2.0f;
	[EntityUtil setEntityRotation:_entityWithOptionsDisplayed rotation:newAngle];
}

-(void) doOptionRotateRight:(id)sender
{
	TransformComponent *transformComponent = (TransformComponent *)[_entityWithOptionsDisplayed getComponent:[TransformComponent class]];
	float newAngle = [transformComponent rotation] + 2.0f;
	[EntityUtil setEntityRotation:_entityWithOptionsDisplayed rotation:newAngle];
}

-(void) doOptionDelete:(id)sender
{
	[_entityWithOptionsDisplayed deleteEntity];
}

-(void) doOptionSetBeeaterBeeType:(id)sender
{
	CCMenuItem *menuItem = (CCMenuItem *)sender;
	NSString *beeTypeAsString = [menuItem userData];
	BeeaterComponent *beeaterComponent = (BeeaterComponent *)[_entityWithOptionsDisplayed getComponent:[BeeaterComponent class]];
	[beeaterComponent setContainedBeeType:[BeeType enumFromName:beeTypeAsString]];
	
	RenderComponent *renderComponent = (RenderComponent *)[_entityWithOptionsDisplayed getComponent:[RenderComponent class]];
	RenderSprite *headRenderSprite = [renderComponent getRenderSprite:@"head"];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [[beeaterComponent containedBeeType] capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
}

-(void) doOptionAddSlingerBeeType:(id)sender
{
	Entity *slingerEntity = _entityWithOptionsDisplayed;
	CCMenuItem *menuItem = (CCMenuItem *)sender;
	NSString *beeTypeAsString = [menuItem userData];
	SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
	
	[slingerComponent pushBeeType:[BeeType enumFromName:beeTypeAsString]];
	
	BeeQueueRenderingSystem *beeQueueRenderingSystem = (BeeQueueRenderingSystem *)[[_world systemManager] getSystem:[BeeQueueRenderingSystem class]];
	[beeQueueRenderingSystem refreshSprites:slingerEntity];
}

-(void) doOptionClearSlingerBees:(id)sender
{
	Entity *slingerEntity = _entityWithOptionsDisplayed;
	SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
	
	[slingerComponent clearBeeTypes];
	
	BeeQueueRenderingSystem *beeQueueRenderingSystem = (BeeQueueRenderingSystem *)[[_world systemManager] getSystem:[BeeQueueRenderingSystem class]];
	[beeQueueRenderingSystem refreshSprites:slingerEntity];
}

@end

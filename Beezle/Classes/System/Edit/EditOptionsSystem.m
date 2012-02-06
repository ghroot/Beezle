//
//  EditRenderingSystem.m
//  Beezle
//
//  Created by Me on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditOptionsSystem.h"
#import "BeeaterComponent.h"
#import "BeeType.h"
#import "EditComponent.h"
#import "EditControlSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "MovementComponent.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

@interface EditOptionsSystem()

-(void) createGeneralOptionsMenu;
-(void) createGeneralEntityOptionsMenu;
-(void) createBeeaterOptionsMenu;
-(void) createSlingerOptionsMenu;
-(void) createMovementOptionsMenu;
-(CCMenuItem *) createMenuItem:(NSString *)label selector:(SEL)selector userData:(void *)userData;
-(void) ensureMenuIsNotInLayer:(CCMenu *)menu;
-(void) removeAllMenus;

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
		[self createMovementOptionsMenu];
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
	[_movementOptionsMenu release];
	
	[super dealloc];
}

-(void) createGeneralOptionsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	_generalOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_generalOptionsMenu setPosition:CGPointMake(winSize.width / 2, 14)];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Beat" selector:@selector(doOptionAddEntity:) userData:@"BEEATER"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"BeatCeil" selector:@selector(doOptionAddEntity:) userData:@"BEEATER-CEILING"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"BeatBird" selector:@selector(doOptionAddEntity:) userData:@"BEEATER-BIRD"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"BeatFish" selector:@selector(doOptionAddEntity:) userData:@"BEEATER-FISH"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Mushroom" selector:@selector(doOptionAddEntity:) userData:@"MUSHROOM"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"SmMushroom" selector:@selector(doOptionAddEntity:) userData:@"SMOKEMUSHROOM"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Nut" selector:@selector(doOptionAddEntity:) userData:@"NUT"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Egg" selector:@selector(doOptionAddEntity:) userData:@"EGG"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Pollen" selector:@selector(doOptionAddEntity:) userData:@"POLLEN"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Ramp" selector:@selector(doOptionAddEntity:) userData:@"RAMP"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Sling" selector:@selector(doOptionAddEntity:) userData:@"SLINGER"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Wood" selector:@selector(doOptionAddEntity:) userData:@"WOOD"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Leaf" selector:@selector(doOptionAddEntity:) userData:@"LEAF"]];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Nest" selector:@selector(doOptionAddEntity:) userData:@"HANGNEST"]];
	[_generalOptionsMenu alignItemsHorizontallyWithPadding:5.0f];
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

-(void) createMovementOptionsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	_movementOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_movementOptionsMenu setPosition:CGPointMake(winSize.width / 2, 34)];
	[_movementOptionsMenu addChild:[self createMenuItem:@"Add move point" selector:@selector(doOptionAddMovementIndicator:) userData:nil]];	
	[_movementOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(CCMenuItem *) createMenuItem:(NSString *)label selector:(SEL)selector userData:(void *)userData
{
	CCMenuItemFont *menuItem = [CCMenuItemFont itemFromString:label target:self selector:selector];
	[menuItem setFontSize:14];
	[menuItem setUserData:userData];
	return menuItem;
}

-(void) initialise
{
	_editControlSystem = (EditControlSystem *)[[_world systemManager] getSystem:[EditControlSystem class]];
}

-(void) begin
{
	if (_entityWithOptionsDisplayed != [_editControlSystem selectedEntity])
	{
		_entityWithOptionsDisplayed = [_editControlSystem selectedEntity];
		
		[self removeAllMenus];
		
		if (_entityWithOptionsDisplayed != nil)
		{
			[_layer addChild:_generalEntityOptionsMenu];
			if ([_entityWithOptionsDisplayed hasComponent:[BeeaterComponent class]])
			{
				[_layer addChild:_beeaterOptionsMenu];
			}
			if ([_entityWithOptionsDisplayed hasComponent:[SlingerComponent class]])
			{
				[_layer addChild:_slingerOptionsMenu];
			}
			if ([_entityWithOptionsDisplayed hasComponent:[MovementComponent class]])
			{
				[_layer addChild:_movementOptionsMenu];
			}
		}
		else
		{
			[_layer addChild:_generalOptionsMenu];
		}
	}
}
		 
-(void) ensureMenuIsNotInLayer:(CCMenu *)menu
{
	for (CCNode *child in [_layer children])
	{
		if (child == menu)
		{
			[_layer removeChild:menu cleanup:TRUE];
			break;
		}
	}
}

-(void) removeAllMenus
{
	[self ensureMenuIsNotInLayer:_generalOptionsMenu];
	[self ensureMenuIsNotInLayer:_generalEntityOptionsMenu];
	[self ensureMenuIsNotInLayer:_beeaterOptionsMenu];
	[self ensureMenuIsNotInLayer:_slingerOptionsMenu];
	[self ensureMenuIsNotInLayer:_movementOptionsMenu];
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
	else if ([type isEqualToString:@"BEEATER-CEILING"])
	{
		entity = [EntityFactory createBeeaterCeiling:_world withBeeType:[BeeType enumFromName:@"BEE"]];
	}
	else if ([type isEqualToString:@"BEEATER-BIRD"])
	{
		entity = [EntityFactory createBeeaterBird:_world withBeeType:[BeeType enumFromName:@"BEE"]];
	}
	else if ([type isEqualToString:@"BEEATER-FISH"])
	{
		entity = [EntityFactory createBeeaterFish:_world withBeeType:[BeeType enumFromName:@"BEE"]];
	}
	else if ([type isEqualToString:@"RAMP"])
	{
		entity = [EntityFactory createRamp:_world];
	}
	else if ([type isEqualToString:@"NUT"])
	{
		entity = [EntityFactory createNut:_world];
	}
	else if ([type isEqualToString:@"EGG"])
	{
		entity = [EntityFactory createEgg:_world];
	}
	else if ([type isEqualToString:@"MUSHROOM"])
	{
		entity = [EntityFactory createMushroom:_world];
	}
	else if ([type isEqualToString:@"SMOKEMUSHROOM"])
	{
		entity = [EntityFactory createSmokeMushroom:_world];
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
	else if ([type isEqualToString:@"LEAF"])
	{
		entity = [EntityFactory createLeaf:_world withMovePositions:[NSArray array]];
	}
	else if ([type isEqualToString:@"HANGNEST"])
	{
		entity = [EntityFactory createHangNest:_world withMovePositions:[NSArray array]];
	}
	
	if (entity != nil)
	{
		[entity addComponent:[EditComponent componentWithLevelLayoutType:type]];
		[entity refresh];
		[EntityUtil setEntityPosition:entity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
		
		[_editControlSystem selectEntity:entity];
	}
}

-(void) doOptionMirror:(id)sender
{
	TransformComponent *transformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	[transformComponent setScale:CGPointMake(-[transformComponent scale].x, [transformComponent scale].y)];
}

-(void) doOptionRotateLeft:(id)sender
{
	TransformComponent *transformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	float newAngle = [transformComponent rotation] - 2.0f;
	[EntityUtil setEntityRotation:_entityWithOptionsDisplayed rotation:newAngle];
}

-(void) doOptionRotateRight:(id)sender
{
	TransformComponent *transformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	float newAngle = [transformComponent rotation] + 2.0f;
	[EntityUtil setEntityRotation:_entityWithOptionsDisplayed rotation:newAngle];
}

-(void) doOptionDelete:(id)sender
{
	// Deselect first if selected
	if (_entityWithOptionsDisplayed == [_editControlSystem selectedEntity])
	{
		[_editControlSystem deselectSelectedEntity];
	}
	
	EditComponent *editComponent = [EditComponent getFrom:_entityWithOptionsDisplayed];
	if ([_entityWithOptionsDisplayed hasComponent:[MovementComponent class]])
	{
		// Delete related movement indicator entities
		Entity *currentMovementIndicatorEntity = [editComponent nextMovementIndicatorEntity];
		while (currentMovementIndicatorEntity != nil)
		{
			EditComponent *movementIndicatorEditComponent = [EditComponent getFrom:currentMovementIndicatorEntity];
			[currentMovementIndicatorEntity deleteEntity];
			currentMovementIndicatorEntity = [movementIndicatorEditComponent nextMovementIndicatorEntity];
		}
	}
	else if ([editComponent mainMoveEntity] != nil)
	{
		// Connect previous EditComponent to next movement indicator
		EditComponent *mainMoveEditComponent = [EditComponent getFrom:[editComponent mainMoveEntity]];
		Entity *currentMovementIndicatorEntity = [mainMoveEditComponent nextMovementIndicatorEntity];
		Entity *previousEntity = [editComponent mainMoveEntity];
		while (currentMovementIndicatorEntity != _entityWithOptionsDisplayed)
		{
			EditComponent *movementIndicatorEditComponent = [EditComponent getFrom:currentMovementIndicatorEntity];
			previousEntity = currentMovementIndicatorEntity;
			currentMovementIndicatorEntity = [movementIndicatorEditComponent nextMovementIndicatorEntity];
		}
		if (previousEntity != nil)
		{
			EditComponent *currentEditComponent = [EditComponent getFrom:currentMovementIndicatorEntity];
			EditComponent *previousEditComponent = [EditComponent getFrom:previousEntity];
			[previousEditComponent setNextMovementIndicatorEntity:[currentEditComponent nextMovementIndicatorEntity]];
		}
	}
	
	[_entityWithOptionsDisplayed deleteEntity];
}

-(void) doOptionSetBeeaterBeeType:(id)sender
{
	CCMenuItem *menuItem = (CCMenuItem *)sender;
	NSString *beeTypeAsString = [menuItem userData];
	BeeaterComponent *beeaterComponent = [BeeaterComponent getFrom:_entityWithOptionsDisplayed];
	[beeaterComponent setContainedBeeType:[BeeType enumFromName:beeTypeAsString]];
	
	RenderComponent *renderComponent = [RenderComponent getFrom:_entityWithOptionsDisplayed];
	RenderSprite *headRenderSprite = [renderComponent getRenderSprite:@"head"];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [[beeaterComponent containedBeeType] capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
}

-(void) doOptionAddSlingerBeeType:(id)sender
{
	Entity *slingerEntity = _entityWithOptionsDisplayed;
	CCMenuItem *menuItem = (CCMenuItem *)sender;
	NSString *beeTypeAsString = [menuItem userData];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	
	[slingerComponent pushBeeType:[BeeType enumFromName:beeTypeAsString]];
	
	// Game notification
	[[NSNotificationCenter defaultCenter] postNotificationName:EDIT_NOTIFICATION_SLINGER_BEE_QUEUE_CHANGED object:self];
}

-(void) doOptionClearSlingerBees:(id)sender
{
	Entity *slingerEntity = _entityWithOptionsDisplayed;
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	
	[slingerComponent clearBeeTypes];
	
	// Game notification
	[[NSNotificationCenter defaultCenter] postNotificationName:EDIT_NOTIFICATION_SLINGER_BEE_QUEUE_CHANGED object:self];
}

-(void) doOptionAddMovementIndicator:(id)sender
{
	// Create movement indicator
	Entity *movementIndicatorEntity = [EntityFactory createMovementIndicator:_world forEntity:_entityWithOptionsDisplayed];
	EditComponent *editComponent = [EditComponent getFrom:movementIndicatorEntity];
	[editComponent setMainMoveEntity:_entityWithOptionsDisplayed];
	
	// Add movement indicator to end of linked list
	EditComponent *currentEditComponent = [EditComponent getFrom:_entityWithOptionsDisplayed];
	TransformComponent *currentTransformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	while ([currentEditComponent nextMovementIndicatorEntity] != nil)
	{
		Entity *nextMovementIndicatorEntity = [currentEditComponent nextMovementIndicatorEntity];
		currentEditComponent = [EditComponent getFrom:nextMovementIndicatorEntity];
		currentTransformComponent = [TransformComponent getFrom:nextMovementIndicatorEntity];
	}
	[currentEditComponent setNextMovementIndicatorEntity:movementIndicatorEntity];
	
	// Set new movement indicator position to be close to last one
	[EntityUtil setEntityPosition:movementIndicatorEntity position:CGPointMake([currentTransformComponent position].x + 20, [currentTransformComponent position].y + 20)];
	
	// Select new movement indicator
	[_editControlSystem selectEntity:movementIndicatorEntity];
}

@end

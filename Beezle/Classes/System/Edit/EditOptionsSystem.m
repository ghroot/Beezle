//
//  EditRenderingSystem.m
//  Beezle
//
//  Created by Me on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditOptionsSystem.h"
#import "BeeaterComponent.h"
#import "BeeaterSystem.h"
#import "BeeQueueRenderingSystem.h"
#import "CapturedComponent.h"
#import "EditComponent.h"
#import "EditControlSystem.h"
#import "EditState.h"
#import "EntityFactory.h"
#import "EntitySelectIngameMenuState.h"
#import "EntityUtil.h"
#import "Game.h"
#import "LevelOrganizer.h"
#import "MovementComponent.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"
#import "Utils.h"

@interface EditOptionsSystem()

-(void) createGeneralOptionsMenu;
-(void) createGeneralEntityOptionsMenu;
-(void) createBeeaterOptionsMenu;
-(void) createSlingerOptionsMenu;
-(void) createMovementOptionsMenu;
-(void) createReflectionOptionsMenu;
-(CCMenuItem *) createMenuItem:(NSString *)label selector:(SEL)selector userData:(void *)userData;
-(void) updateMenus;
-(void) ensureMenuIsNotInLayer:(CCMenu *)menu;
-(void) removeAllMenus;

-(void) doOptionOpenEntityMenu:(id)sender;
-(void) doOptionToggleWater:(id)sender;
-(void) doOptionToggleLines:(id)sender;

-(void) doOptionMirror:(id)sender;
-(void) doOptionRotateLeft:(id)sender;
-(void) doOptionRotateRight:(id)sender;
-(void) doOptionDelete:(id)sender;

-(void) doOptionSetBeeaterBeeType:(id)sender;

-(void) doOptionAddSlingerBeeType:(id)sender;
-(void) doOptionClearSlingerBees:(id)sender;

-(void) doOptionAddMovementIndicator:(id)sender;

-(void) doOptionToggleReflection:(id)sender;

@end

@implementation EditOptionsSystem

-(id) initWithLayer:(CCLayer *)layer andEditState:(EditState *)editState
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[EditComponent class]]])
	{
		_layer = layer;
		_editState = editState;
		
		[self createGeneralOptionsMenu];
		[self createGeneralEntityOptionsMenu];
		[self createBeeaterOptionsMenu];
		[self createSlingerOptionsMenu];
		[self createMovementOptionsMenu];
		[self createReflectionOptionsMenu];
		
		[self updateMenus];
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
	_generalOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_generalOptionsMenu addChild:[self createMenuItem:@"Add entity" selector:@selector(doOptionOpenEntityMenu:) userData:nil]];
	
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:[_editState levelName]];
	if ([theme isEqualToString:@"A"])
	{
		[_generalOptionsMenu addChild:[self createMenuItem:@"Toggle water" selector:@selector(doOptionToggleWater:) userData:nil]];
	}
	else if ([theme isEqualToString:@"B"])
	{
		[_generalOptionsMenu addChild:[self createMenuItem:@"Toggle lava" selector:@selector(doOptionToggleWater:) userData:nil]];
	}
	
	[_generalOptionsMenu addChild:[self createMenuItem:@"Toggle lines" selector:@selector(doOptionToggleLines:) userData:nil]];
	[_generalOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createGeneralEntityOptionsMenu
{
	_generalEntityOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Mirror" selector:@selector(doOptionMirror:) userData:nil]];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Rotate Left" selector:@selector(doOptionRotateLeft:) userData:nil]];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Rotate Right" selector:@selector(doOptionRotateRight:) userData:nil]];
	[_generalEntityOptionsMenu addChild:[self createMenuItem:@"Delete" selector:@selector(doOptionDelete:) userData:nil]];
	[_generalEntityOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createBeeaterOptionsMenu
{
	_beeaterOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Bee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"BEE"]];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Bombee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"BOMBEE"]];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Speedee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"SPEEDEE"]];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Sawee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"SAWEE"]];
	[_beeaterOptionsMenu addChild:[self createMenuItem:@"Sumee" selector:@selector(doOptionSetBeeaterBeeType:) userData:@"SUMEE"]];
	[_beeaterOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createSlingerOptionsMenu
{
	_slingerOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Bee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"BEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Bombee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"BOMBEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Speedee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"SPEEDEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Sawee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"SAWEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Sumee" selector:@selector(doOptionAddSlingerBeeType:) userData:@"SUMEE"]];
	[_slingerOptionsMenu addChild:[self createMenuItem:@"Clear" selector:@selector(doOptionClearSlingerBees:) userData:nil]];	
	[_slingerOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createMovementOptionsMenu
{
	_movementOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_movementOptionsMenu addChild:[self createMenuItem:@"Add move point" selector:@selector(doOptionAddMovementIndicator:) userData:nil]];	
	[_movementOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(void) createReflectionOptionsMenu
{
	_reflectionOptionsMenu = [[CCMenu menuWithItems:nil] retain];
	[_reflectionOptionsMenu addChild:[self createMenuItem:@"Toggle reflection" selector:@selector(doOptionToggleReflection:) userData:nil]];
	[_reflectionOptionsMenu alignItemsHorizontallyWithPadding:20.0f];
}

-(CCMenuItem *) createMenuItem:(NSString *)label selector:(SEL)selector userData:(void *)userData
{
	CCMenuItemFont *menuItem = [CCMenuItemFont itemWithString:label target:self selector:selector];
	[menuItem setFontSize:14];
	[menuItem setUserData:userData];
	return menuItem;
}

-(void) initialise
{
	_editControlSystem = (EditControlSystem *)[[_world systemManager] getSystem:[EditControlSystem class]];
	_beeQueueRenderingSystem = (BeeQueueRenderingSystem *)[[_world systemManager] getSystem:[BeeQueueRenderingSystem class]];
	_beeaterSystem = (BeeaterSystem *)[[_world systemManager] getSystem:[BeeaterSystem class]];
}

-(void) begin
{
	if (_entityWithOptionsDisplayed != [_editControlSystem selectedEntity])
	{
		[self updateMenus];
	}
}

-(void) updateMenus
{
	_entityWithOptionsDisplayed = [_editControlSystem selectedEntity];
	
	[self removeAllMenus];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int currentX = winSize.width / 2;
	int currentY = 14;
	
	if (_entityWithOptionsDisplayed != nil)
	{
		[_generalEntityOptionsMenu setPosition:CGPointMake(currentX, currentY)];
		currentY += 20;
		[_layer addChild:_generalEntityOptionsMenu];
		
		if ([_entityWithOptionsDisplayed hasComponent:[BeeaterComponent class]])
		{
			[_beeaterOptionsMenu setPosition:CGPointMake(currentX, currentY)];
			currentY += 20;
			[_layer addChild:_beeaterOptionsMenu];
		}
		if ([_entityWithOptionsDisplayed hasComponent:[SlingerComponent class]])
		{
			[_slingerOptionsMenu setPosition:CGPointMake(currentX, currentY)];
			currentY += 20;
			[_layer addChild:_slingerOptionsMenu];
		}
		if ([_entityWithOptionsDisplayed hasComponent:[MovementComponent class]])
		{
			[_movementOptionsMenu setPosition:CGPointMake(currentX, currentY)];
			currentY += 20;
			[_layer addChild:_movementOptionsMenu];
		}
		EditComponent *editComponent = [EditComponent getFrom:_entityWithOptionsDisplayed];
		if ([[editComponent levelLayoutType] hasPrefix:@"BEEATER-LAND-C"] ||
			[[editComponent levelLayoutType] hasPrefix:@"BEEATER-HANGING-C"] ||
			[[editComponent levelLayoutType] hasPrefix:@"EGG"] ||
			[[editComponent levelLayoutType] hasPrefix:@"MUSHROOM"] ||
			[[editComponent levelLayoutType] hasPrefix:@"SMOKE-MUSHROOM"])
		{
			[_reflectionOptionsMenu setPosition:CGPointMake(currentX, currentY)];
			[_layer addChild:_reflectionOptionsMenu];
		}
	}
	else
	{
		[_generalOptionsMenu setPosition:CGPointMake(currentX, currentY)];
		[_layer addChild:_generalOptionsMenu];
	}
}
		 
-(void) ensureMenuIsNotInLayer:(CCMenu *)menu
{
	for (CCNode *child in [_layer children])
	{
		if (child == menu)
		{
			[_layer removeChild:menu cleanup:FALSE];
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
	[self ensureMenuIsNotInLayer:_reflectionOptionsMenu];
}

-(void) doOptionOpenEntityMenu:(id)sender
{
	Game *game = [_editState game];
	[game pushState:[EntitySelectIngameMenuState state]];
}
	 
-(void) doOptionToggleWater:(id)sender
{
	Entity *waterEntity = [EntityUtil getWaterEntity:_world];
	if (waterEntity != nil)
	{
		[waterEntity deleteEntity];
	}
	else
	{
		[EntityFactory createWater:_world withLevelName:[_editState levelName]];
	}
}

-(void) doOptionToggleLines:(id)sender
{
	[_editState toggleDebugPhysicsDrawing];
}

-(void) doOptionMirror:(id)sender
{
	TransformComponent *transformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	[transformComponent setScale:CGPointMake(-[transformComponent scale].x, [transformComponent scale].y)];
}

-(void) doOptionRotateLeft:(id)sender
{
	TransformComponent *transformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	float newAngle = [Utils unwindAngleDegrees:[transformComponent rotation] - 2.0f];
	[EntityUtil setEntityRotation:_entityWithOptionsDisplayed rotation:newAngle];
}

-(void) doOptionRotateRight:(id)sender
{
	TransformComponent *transformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	float newAngle = [Utils unwindAngleDegrees:[transformComponent rotation] + 2.0f];
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
	CapturedComponent *capturedComponent = [CapturedComponent getFrom:_entityWithOptionsDisplayed];
	[capturedComponent setContainedBeeType:[BeeType enumFromName:beeTypeAsString]];
	[_beeaterSystem animateBeeater:_entityWithOptionsDisplayed];
}

-(void) doOptionAddSlingerBeeType:(id)sender
{
	Entity *slingerEntity = _entityWithOptionsDisplayed;
	CCMenuItem *menuItem = (CCMenuItem *)sender;
	NSString *beeTypeAsString = [menuItem userData];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	
	[slingerComponent pushBeeType:[BeeType enumFromName:beeTypeAsString]];
	
	[_beeQueueRenderingSystem refreshSprites];
}

-(void) doOptionClearSlingerBees:(id)sender
{
	Entity *slingerEntity = _entityWithOptionsDisplayed;
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	
	[slingerComponent clearBeeTypes];
	
	[_beeQueueRenderingSystem refreshSprites];
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

-(void) doOptionToggleReflection:(id)sender
{
	TransformComponent *transformComponent = [TransformComponent getFrom:_entityWithOptionsDisplayed];
	
	// Deselect first if selected
	if (_entityWithOptionsDisplayed == [_editControlSystem selectedEntity])
	{
		[_editControlSystem deselectSelectedEntity];
	}
	
	// Delete entity
	[_entityWithOptionsDisplayed deleteEntity];
	
	EditComponent *editComponent = [EditComponent getFrom:_entityWithOptionsDisplayed];
	NSString *levelLayoutType = [editComponent levelLayoutType];
	
	NSString *entityType = nil;
	if ([levelLayoutType hasSuffix:@"-REFLECTION"])
	{
		entityType = [levelLayoutType stringByReplacingOccurrencesOfString:@"-REFLECTION" withString:@""];
	}
	else
	{
		entityType = [NSString stringWithFormat:@"%@-REFLECTION", levelLayoutType];
	}
	
	NSMutableDictionary *instanceComponentsDict = nil;
	
	if ([[editComponent levelLayoutType] hasPrefix:@"BEEATER-"])
	{
		CapturedComponent *capturedComponent = [CapturedComponent getFrom:_entityWithOptionsDisplayed];
		instanceComponentsDict = [NSMutableDictionary dictionary];
		NSMutableDictionary *capturedComponentDict = [NSMutableDictionary dictionary];
		[capturedComponentDict setObject:[[capturedComponent containedBeeType] name] forKey:@"containedBeeType"];
		[instanceComponentsDict setObject:capturedComponentDict forKey:@"captured"];
	}
	
	Entity *entity = [EntityFactory createEntity:entityType world:_world instanceComponentsDict:instanceComponentsDict edit:TRUE];
	[EntityUtil setEntityPosition:entity position:[transformComponent position]];
	[EntityUtil setEntityRotation:entity rotation:[transformComponent rotation]];
	[EntityUtil setEntityMirrored:entity mirrored:([transformComponent scale].x < 0)];
	[_editControlSystem selectEntity:entity];
}

@end

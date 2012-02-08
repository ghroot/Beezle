//
//  LevelLoader.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLoader.h"
#import "BeeaterComponent.h"
#import "BeeType.h"
#import "EditComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "LevelLoader.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"
#import "Utils.h"

@interface LevelLoader()

-(LevelLayout *) loadLevelLayoutFromFile:(NSString *)filePath isEdited:(BOOL)isEdited;

@end

@implementation LevelLoader

+(LevelLoader *) sharedLoader
{
    static LevelLoader *loader = 0;
    if (!loader)
    {
        loader = [[self alloc] init];
    }
    return loader;
}

-(LevelLayout *) loadLevelLayoutFromFile:(NSString *)filePath isEdited:(BOOL)isEdited
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	if (dict != nil)
	{
		LevelLayout *levelLayout = [LevelLayout layoutWithContentsOfDictionary:dict];
		[levelLayout setIsEdited:isEdited];
		return levelLayout;
	}
	else
	{
		return nil;
	}
}

-(LevelLayout *) loadLevelLayoutOriginal:(NSString *)levelName
{
	// Load from bundle
	NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
	NSString *filePath = [CCFileUtils fullPathFromRelativePath:levelFileName];
	return [self loadLevelLayoutFromFile:filePath isEdited:FALSE];
}

-(LevelLayout *) loadLevelLayoutEdited:(NSString *)levelName
{
	// From from document directory
	NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
	return [self loadLevelLayoutFromFile:filePath isEdited:TRUE];
}

-(LevelLayout *) loadLevelLayoutWithHighestVersion:(NSString *)levelName
{
	LevelLayout *originalLevelLayout = [self loadLevelLayoutOriginal:levelName];
	LevelLayout *editedLevelLayout = [self loadLevelLayoutEdited:levelName];
	if (editedLevelLayout != nil &&
		[editedLevelLayout version] > [originalLevelLayout version])
	{
		return editedLevelLayout;
	}
	else
	{
		return originalLevelLayout;
	}
}

-(void) loadLevel:(NSString *)levelName inWorld:(World *)world edit:(BOOL)edit
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	
	if (levelLayout == nil)
	{
		levelLayout = [self loadLevelLayoutWithHighestVersion:levelName];
		[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayout:levelLayout];
		
		if (levelLayout != nil)
		{
			NSLog(@"Loading %@v%i", [levelLayout levelName], [levelLayout version]);
		}
		else
		{
			NSLog(@"Could not load %@", levelName);
		}
	}
	
	// Background
	Entity *backgroundEntity = [EntityFactory createBackground:world withLevelName:levelName];
	[EntityUtil setEntityPosition:backgroundEntity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
	
	// Edge
    [EntityFactory createEdge:world];
	
    for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
    {
		Entity *entity = [EntityFactory createEntity:[levelLayoutEntry type] world:world];
		
		if (CONFIG_CAN_EDIT_LEVELS)
		{
			EditComponent *editComponent = [EditComponent componentWithLevelLayoutType:[levelLayoutEntry type]];
			[entity addComponent:editComponent];
			[entity refresh];
		}
		
		if ([[levelLayoutEntry componentsDict] objectForKey:@"beeater"] != nil)
		{
			NSDictionary *beeaterDict = [[levelLayoutEntry componentsDict] objectForKey:@"beeater"];
			if ([beeaterDict objectForKey:@"containedBeeType"])
			{
				NSString *containedBeeTypeAsString = [beeaterDict objectForKey:@"containedBeeType"];
				BeeType *containedBeeType = [BeeType enumFromName:containedBeeTypeAsString];
				[[BeeaterComponent getFrom:entity] setContainedBeeType:containedBeeType];
				
				[EntityUtil animateBeeaterHeadBasedOnContainedBeeType:entity];
			}
		}
		
		if ([[levelLayoutEntry componentsDict] objectForKey:@"movement"] != nil)
		{
			NSDictionary *movementDict = [[levelLayoutEntry componentsDict] objectForKey:@"movement"];
			
			NSArray *positionsAsStrings = [movementDict objectForKey:@"positions"];
			NSMutableArray *positions = [NSMutableArray array];
			for (NSString *positionAsString in positionsAsStrings)
			{
				CGPoint position = [Utils stringToPoint:positionAsString];
				[positions addObject:[NSValue valueWithCGPoint:position]];
			}
			
			if (edit)
			{
				// Load movement points as movement indicator entities to allow for editing
				EditComponent *currentEditComponent = [EditComponent getFrom:entity];
				for (NSValue *movePositionAsValue in positions)
				{
					Entity *movementIndicator = [EntityFactory createMovementIndicator:world forEntity:entity];
					[EntityUtil setEntityPosition:movementIndicator position:[movePositionAsValue CGPointValue]];
					[currentEditComponent setNextMovementIndicatorEntity:movementIndicator];
					[currentEditComponent setMainMoveEntity:entity];
					currentEditComponent = (EditComponent *)[movementIndicator getComponent:[EditComponent class]];
				}
				[currentEditComponent setMainMoveEntity:entity];
			}
			else
			{
				// Load movement points normally
				[[MovementComponent getFrom:entity] setPositions:positions];
			}

		}
		
		if ([[levelLayoutEntry componentsDict] objectForKey:@"slinger"] != nil)
		{
			NSDictionary *slingerDict = [[levelLayoutEntry componentsDict] objectForKey:@"slinger"];
			if ([slingerDict objectForKey:@"queuedBeeTypes"])
			{
				NSArray *queuedBeeTypesAsStrings = [slingerDict objectForKey:@"queuedBeeTypes"];
				for (NSString *queuedBeeTypeAsString in queuedBeeTypesAsStrings)
				{
					BeeType *queuedBeeType = [BeeType enumFromName:queuedBeeTypeAsString];
					[[SlingerComponent getFrom:entity] pushBeeType:queuedBeeType];
				}
			}
		}
		
		if ([[levelLayoutEntry componentsDict] objectForKey:@"transform"] != nil)
		{
			NSDictionary *transformDict = [[levelLayoutEntry componentsDict] objectForKey:@"transform"];
			if ([transformDict objectForKey:@"position"] != nil)
			{
				CGPoint position = [Utils stringToPoint:[transformDict objectForKey:@"position"]];
				[EntityUtil setEntityPosition:entity position:position];
			}
			if ([transformDict objectForKey:@"rotation"] != nil)
			{
				float rotation = [[transformDict objectForKey:@"rotation"] floatValue];
				[EntityUtil setEntityRotation:entity rotation:rotation];
			}
			if ([transformDict objectForKey:@"scale"] != nil)
			{
				CGPoint scale = [Utils stringToPoint:[transformDict objectForKey:@"scale"]];
				TransformComponent *transformComponent = [TransformComponent getFrom:entity];
				[transformComponent setScale:CGPointMake([transformComponent scale].x * scale.x, [transformComponent scale].y * scale.y)];
			}
		}
    }
}

@end

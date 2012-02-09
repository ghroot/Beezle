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
#import "DisposableComponent.h"
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
		
		if ([[levelLayoutEntry componentsDict] objectForKey:@"movement"] != nil)
		{
			NSDictionary *movementDict = [[levelLayoutEntry componentsDict] objectForKey:@"movement"];
			[[MovementComponent getFrom:entity] populateWithContentsOfDictionary:movementDict world:world];
		}
		
		// TODO: How do we get rid of this?
		if (CONFIG_CAN_EDIT_LEVELS && edit)
		{
			if ([[levelLayoutEntry componentsDict] objectForKey:@"movement"] != nil)
			{
				// Load movement points as movement indicator entities to allow for editing
				MovementComponent *movementComponent = [MovementComponent getFrom:entity];
				EditComponent *currentEditComponent = [EditComponent getFrom:entity];
				for (NSValue *movePositionAsValue in [movementComponent positions])
				{
					Entity *movementIndicator = [EntityFactory createMovementIndicator:world forEntity:entity];
					[EntityUtil setEntityPosition:movementIndicator position:[movePositionAsValue CGPointValue]];
					[currentEditComponent setNextMovementIndicatorEntity:movementIndicator];
					[currentEditComponent setMainMoveEntity:entity];
					currentEditComponent = (EditComponent *)[movementIndicator getComponent:[EditComponent class]];
				}
				[currentEditComponent setMainMoveEntity:entity];
			}
		}
		
		if ([[levelLayoutEntry componentsDict] objectForKey:@"beeater"] != nil)
		{
			NSDictionary *beeaterDict = [[levelLayoutEntry componentsDict] objectForKey:@"beeater"];
			[[BeeaterComponent getFrom:entity] populateWithContentsOfDictionary:beeaterDict world:world];
		}
		if ([[levelLayoutEntry componentsDict] objectForKey:@"disposable"] != nil)
		{
			NSDictionary *disposableDict = [[levelLayoutEntry componentsDict] objectForKey:@"disposable"];
			[[DisposableComponent getFrom:entity] populateWithContentsOfDictionary:disposableDict world:world];
		}
		if ([[levelLayoutEntry componentsDict] objectForKey:@"physics"] != nil)
		{
			NSDictionary *physicsDict = [[levelLayoutEntry componentsDict] objectForKey:@"physics"];
			[[PhysicsComponent getFrom:entity] populateWithContentsOfDictionary:physicsDict world:world];
		}
		if ([[levelLayoutEntry componentsDict] objectForKey:@"render"] != nil)
		{
			NSDictionary *renderDict = [[levelLayoutEntry componentsDict] objectForKey:@"render"];
			[[RenderComponent getFrom:entity] populateWithContentsOfDictionary:renderDict world:world];
		}
		if ([[levelLayoutEntry componentsDict] objectForKey:@"slinger"] != nil)
		{
			NSDictionary *slingerDict = [[levelLayoutEntry componentsDict] objectForKey:@"slinger"];
			[[SlingerComponent getFrom:entity] populateWithContentsOfDictionary:slingerDict world:world];
		}
		if ([[levelLayoutEntry componentsDict] objectForKey:@"transform"] != nil)
		{
			NSDictionary *transformDict = [[levelLayoutEntry componentsDict] objectForKey:@"transform"];
			[[TransformComponent getFrom:entity] populateWithContentsOfDictionary:transformDict world:world];
		}
    }
}

@end

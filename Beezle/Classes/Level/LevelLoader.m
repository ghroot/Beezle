//
//  LevelLoader.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLoader.h"
#import "BeeaterComponent.h"
#import "DisposableComponent.h"
#import "EditComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "GateComponent.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "LevelLoader.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "PlayerInformation.h"
#import "RenderComponent.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

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
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	if (levelLayout == nil)
	{
		levelLayout = [self loadLevelLayoutWithHighestVersion:levelName];
		if (levelLayout != nil)
		{
			[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayout:levelLayout];
		}
		
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
	[EntityFactory createBackground:world withLevelName:levelName];
	
	// Edge
    [EntityFactory createEdge:world];
	
	// Entities
    for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
    {
		Entity *entity = [EntityFactory createEntity:[levelLayoutEntry type] world:world];
		
		if (CONFIG_CAN_EDIT_LEVELS && edit)
		{
			[entity addComponent:[EditComponent componentWithLevelLayoutType:[levelLayoutEntry type]]];
			[entity refresh];
		}
		
		if ([[levelLayoutEntry componentsDict] objectForKey:@"beeater"] != nil)
		{
			NSDictionary *beeaterDict = [[levelLayoutEntry componentsDict] objectForKey:@"beeater"];
			[[BeeaterComponent getFrom:entity] populateWithContentsOfDictionary:beeaterDict world:world];
		}
		if ([[levelLayoutEntry componentsDict] objectForKey:@"disposable"] != nil)
		{
			NSDictionary *disposableDict = [[levelLayoutEntry componentsDict] objectForKey:@"disposable"];
			DisposableComponent *disposableComponent = [DisposableComponent getFrom:entity];
			[disposableComponent populateWithContentsOfDictionary:disposableDict world:world];
		}
		if ([[levelLayoutEntry componentsDict] objectForKey:@"movement"] != nil)
		{
			NSDictionary *movementDict = [[levelLayoutEntry componentsDict] objectForKey:@"movement"];
			[[MovementComponent getFrom:entity] populateWithContentsOfDictionary:movementDict world:world edit:edit];
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

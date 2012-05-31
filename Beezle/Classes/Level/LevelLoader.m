//
//  LevelLoader.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLoader.h"
#import "EntityFactory.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"

@interface LevelLoader()

-(LevelLayout *) loadLevelLayoutFromFile:(NSString *)filePath isEdited:(BOOL)isEdited;
-(void) createEntities:(NSArray *)entries levelName:(NSString *)levelName world:(World *)world edit:(BOOL)edit;

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
	NSString *filePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:levelFileName];
	return [self loadLevelLayoutFromFile:filePath isEdited:FALSE];
}

-(LevelLayout *) loadLevelLayoutEdited:(NSString *)levelName
{
	// Load from document directory
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
	else if (originalLevelLayout != nil)
	{
		return originalLevelLayout;
	}
	else
	{
		return nil;
	}
}

-(void) loadLevel:(NSString *)levelName inWorld:(World *)world edit:(BOOL)edit
{
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	
	[EntityFactory createEdge:world];
	[EntityFactory createBackground:world withLevelName:levelName];
	
	if (levelLayout != nil)
	{
		[self createEntities:[levelLayout entries] levelName:levelName world:world edit:edit];
		if ([levelLayout hasWater])
		{
			[EntityFactory createWater:world withLevelName:levelName];
		}
	}
}

-(void) createEntities:(NSArray *)entries levelName:(NSString *)levelName world:(World *)world edit:(BOOL)edit
{
	for (LevelLayoutEntry *levelLayoutEntry in entries)
	{
		Entity *entity = [EntityFactory createEntity:[levelLayoutEntry type] world:world instanceComponentsDict:[levelLayoutEntry instanceComponentsDict] edit:edit];
		
		if (entity == nil)
		{
			NSLog(@"Unsupported entity type in layout %@: %@", levelName, [levelLayoutEntry type]);
		}
	}
}

@end

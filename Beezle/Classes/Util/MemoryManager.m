//
//  MemoryManager.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/12/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemoryManager.h"
#import "LevelLayoutCache.h"
#import "EntityDescriptionCache.h"

@interface MemoryManager()

-(void) unloadSpriteSheet:(NSString *)spriteSheetName;

@end

@implementation MemoryManager

+(MemoryManager *) sharedManager
{
	static MemoryManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(void) purgeCachedData
{
	[[CCDirector sharedDirector] purgeCachedData];
	[[LevelLayoutCache sharedLevelLayoutCache] purgeAllCachedLevelLayouts];
	[[EntityDescriptionCache sharedCache] purgeCachedData];
}

-(void) ensureThemeSpriteSheetIsUniquelyLoaded:(NSString *)spriteSheetName
{
	if (_loadedThemeSpriteSheetName != nil &&
		![_loadedThemeSpriteSheetName isEqualToString:spriteSheetName])
	{
		[self unloadSpriteSheet:_loadedThemeSpriteSheetName];
		[_loadedThemeSpriteSheetName release];
	}
	_loadedThemeSpriteSheetName = [spriteSheetName copy];
}

-(void) ensureThemeBossSpriteSheetIsUniquelyLoaded:(NSString *)spriteSheetName
{
	if (_loadedThemeBossSpriteSheetName != nil &&
		![_loadedThemeBossSpriteSheetName isEqualToString:spriteSheetName])
	{
		[self unloadSpriteSheet:_loadedThemeBossSpriteSheetName];
		[_loadedThemeBossSpriteSheetName release];
	}
	_loadedThemeBossSpriteSheetName = [spriteSheetName copy];
}

-(void) unloadSpriteSheet:(NSString *)spriteSheetName
{
	NSString *spriteFramesFileName = [NSString stringWithFormat:@"%@.plist", spriteSheetName];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:spriteFramesFileName];
	NSString *textureFileName = [NSString stringWithFormat:@"%@.png", spriteSheetName];
	[[CCTextureCache sharedTextureCache] removeTextureForKey:textureFileName];
}

@end

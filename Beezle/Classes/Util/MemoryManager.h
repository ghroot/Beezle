//
//  MemoryManager.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/12/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface MemoryManager : NSObject
{
	NSString *_loadedThemeSpriteSheetName;
	NSString *_loadedThemeBossSpriteSheetName;
}

+(MemoryManager *) sharedManager;

-(void) purgeCachedData;
-(void) ensureThemeSpriteSheetIsUniquelyLoaded:(NSString *)spriteSheetName;
-(void) ensureThemeBossSpriteSheetIsUniquelyLoaded:(NSString *)spriteSheetName;

@end

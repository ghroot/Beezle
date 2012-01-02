//
//  LevelLoader.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLoader.h"
#import "BeeTypes.h"
#import "EditComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"

@implementation LevelLoader

+(LevelLoader *) sharedLoader
{
    static LevelLoader *loader = 0;
    if(!loader)
    {
        loader = [[self alloc] init];
    }
    return loader;
}

-(void) loadLevel:(NSString *)levelName inWorld:(World *)world
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	
	NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
	
	if (levelLayout == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		if (dict != nil)
		{
			[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayoutsWithDictionary:dict];
		}
		else
		{
			[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayoutsWithFile:levelFileName];
		}
		levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		
		NSLog(@"Loading %@v%i", [levelLayout levelName], [levelLayout version]);
	}
	
	Entity *backgroundEntity = [EntityFactory createBackground:world withLevelName:levelName];
	[EntityUtil setEntityPosition:backgroundEntity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
	
    [EntityFactory createEdge:world];
	
    for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
    {
		Entity *entity = nil;
		
        if ([[levelLayoutEntry type] isEqualToString:@"SLINGER"])
        {
            NSMutableArray *beeTypes = [NSMutableArray array];
            for (NSString *beeTypeAsString in [levelLayoutEntry beeTypesAsStrings])
            {
                BeeTypes *beeType = [BeeTypes beeTypeFromString:beeTypeAsString];
                [beeTypes addObject:beeType];
            }
            
            entity = [EntityFactory createSlinger:world withBeeTypes:beeTypes];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"BEEATER"])
        {
            BeeTypes *beeType = [BeeTypes beeTypeFromString:[levelLayoutEntry beeTypeAsString]];
            entity = [EntityFactory createBeeater:world withBeeType:beeType];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"RAMP"])
        {
            entity = [EntityFactory createRamp:world];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"POLLEN"])
        {
            entity = [EntityFactory createPollen:world];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"MUSHROOM"])
        {
            entity = [EntityFactory createMushroom:world];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"WOOD"])
        {
            entity = [EntityFactory createWood:world];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"NUT"])
        {
            entity = [EntityFactory createNut:world];
        }

		NSAssert(entity != nil, @"Unrecognized level layout entry type: %@", [levelLayoutEntry type]);
		
		if (entity != nil)
		{
			[EntityUtil setEntityPosition:entity position:[levelLayoutEntry position]];
			[EntityUtil setEntityRotation:entity rotation:[levelLayoutEntry rotation]];
			[EntityUtil setEntityMirrored:entity mirrored:[levelLayoutEntry mirrored]];
		}
		
		if (CONFIG_CAN_EDIT_LEVELS)
		{
			EditComponent *editComponent = [EditComponent component];
			[editComponent setLevelLayoutType:[levelLayoutEntry type]];
			[entity addComponent:editComponent];
			[entity refresh];
		}
    }
}

@end

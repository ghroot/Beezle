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
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"

@implementation LevelLoader

+(LevelLoader *) loader
{
	return [[[self alloc] init] autorelease];
}

-(void) loadLevel:(NSString *)levelName inWorld:(World *)world
{
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	
	if (levelLayout == nil)
	{
		NSString *layoutFile = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
		[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayoutsWithFile:layoutFile];
		
		levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	}
	
	[EntityFactory createBackground:world withLevelName:levelName];
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
            
            entity = [EntityFactory createSlinger:world withPosition:[levelLayoutEntry position] beeTypes:beeTypes];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"BEEATER"])
        {
            BeeTypes *beeType = [BeeTypes beeTypeFromString:[levelLayoutEntry beeTypeAsString]];
            entity = [EntityFactory createBeeater:world withPosition:[levelLayoutEntry position] mirrored:[levelLayoutEntry mirrored] beeType:beeType];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"RAMP"])
        {
            entity = [EntityFactory createRamp:world withPosition:[levelLayoutEntry position] andRotation:[levelLayoutEntry rotation]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"POLLEN"])
        {
            entity = [EntityFactory createPollen:world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"MUSHROOM"])
        {
            entity = [EntityFactory createMushroom:world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"WOOD"])
        {
            entity = [EntityFactory createWood:world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"NUT"])
        {
            entity = [EntityFactory createNut:world withPosition:[levelLayoutEntry position]];
        }

		NSAssert(entity != nil, @"Unrecognized level layout entry type: %@", [levelLayoutEntry type]);
		
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

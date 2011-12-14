//
//  LevelLoader.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLoader.h"
#import "BeeTypes.h"
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
	[EntityFactory createBackground:world withLevelName:levelName];
    [EntityFactory createEdge:world];
    
    NSString *layoutFile = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
    [[LevelLayoutCache sharedLevelLayoutCache] addLevelLayoutsWithFile:layoutFile];
    LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
    for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
    {
        if ([[levelLayoutEntry type] isEqualToString:@"SLINGER"])
        {
            NSMutableArray *beeTypes = [NSMutableArray array];
            for (NSString *beeTypeAsString in [levelLayoutEntry beeTypesAsStrings])
            {
                BeeTypes *beeType = [BeeTypes beeTypeFromString:beeTypeAsString];
                [beeTypes addObject:beeType];
            }
            
            [EntityFactory createSlinger:world withPosition:[levelLayoutEntry position] beeTypes:beeTypes];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"BEEATER"])
        {
            BeeTypes *beeType = [BeeTypes beeTypeFromString:[levelLayoutEntry beeTypeAsString]];
            [EntityFactory createBeeater:world withPosition:[levelLayoutEntry position] mirrored:[levelLayoutEntry mirrored] beeType:beeType];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"RAMP"])
        {
            [EntityFactory createRamp:world withPosition:[levelLayoutEntry position] andRotation:[levelLayoutEntry rotation]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"POLLEN"])
        {
            [EntityFactory createPollen:world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"MUSHROOM"])
        {
            [EntityFactory createMushroom:world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"WOOD"])
        {
            [EntityFactory createWood:world withPosition:[levelLayoutEntry position]];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"NUT"])
        {
            [EntityFactory createNut:world withPosition:[levelLayoutEntry position]];
        }
    }
}

@end

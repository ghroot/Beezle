//
//  LevelLoader.m
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLoader.h"
#import "BeeType.h"
#import "EditComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "LevelLoader.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"

@interface LevelLoader()

-(BOOL) loadLevelLayoutFromFile:(NSString *)filePath isEdited:(BOOL)isEdited;

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

-(BOOL) loadLevelLayoutFromFile:(NSString *)filePath isEdited:(BOOL)isEdited
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	if (dict != nil)
	{
		LevelLayout *levelLayout = [LevelLayout layoutWithContentsOfDictionary:dict];
		[levelLayout setIsEdited:isEdited];
		[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayout:levelLayout];
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

-(BOOL) loadLevelLayoutOriginal:(NSString *)levelName
{
	// Load from bundle
	NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
	NSString *filePath = [CCFileUtils fullPathFromRelativePath:levelFileName];
	return [self loadLevelLayoutFromFile:filePath isEdited:FALSE];
}

-(BOOL) loadLevelLayoutEdited:(NSString *)levelName
{
	// From from document directory
	NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
	return [self loadLevelLayoutFromFile:filePath isEdited:TRUE];
}

-(void) loadLevel:(NSString *)levelName inWorld:(World *)world edit:(BOOL)edit
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	
	if (levelLayout == nil)
	{
		[[LevelLoader sharedLoader] loadLevelLayoutOriginal:levelName];
		if (CONFIG_CAN_EDIT_LEVELS)
		{
			// Will replace original if it exists
			[[LevelLoader sharedLoader] loadLevelLayoutEdited:levelName];
		}
		levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		
		if (levelLayout != nil)
		{
			NSLog(@"Loading %@v%i", [levelLayout levelName], [levelLayout version]);
		}
		else
		{
			NSLog(@"Could not load %@", levelName);
		}
	}
	
	Entity *backgroundEntity = [EntityFactory createBackground:world withLevelName:levelName];
	[EntityUtil setEntityPosition:backgroundEntity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
	
    [EntityFactory createEdge:world];
	
    for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
    {
		Entity *entity = nil;
		EditComponent *editComponent = [EditComponent componentWithLevelLayoutType:[levelLayoutEntry type]];
		
        if ([[levelLayoutEntry type] isEqualToString:@"SLINGER"])
        {
            NSMutableArray *beeTypes = [NSMutableArray array];
            for (NSString *beeTypeAsString in [levelLayoutEntry beeTypesAsStrings])
            {
                BeeType *beeType = [BeeType enumFromName:beeTypeAsString];
                [beeTypes addObject:beeType];
            }
            
            entity = [EntityFactory createSlinger:world withBeeTypes:beeTypes];
        }
        else if ([[levelLayoutEntry type] isEqualToString:@"BEEATER"])
        {
            BeeType *beeType = [BeeType enumFromName:[levelLayoutEntry beeTypeAsString]];
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
		else if ([[levelLayoutEntry type] isEqualToString:@"LEAF"])
		{
			if (edit)
			{
				// Load movement points as movement indicator entities to allow for editing
				entity = [EntityFactory createLeaf:world withMovePositions:[NSArray array]];
				EditComponent *currentEditComponent = editComponent;
				for (NSValue *movePositionAsValue in [levelLayoutEntry movePositions])
				{
					Entity *movementIndicator = [EntityFactory createMovementIndicator:world];
					[EntityUtil setEntityPosition:movementIndicator position:[movePositionAsValue CGPointValue]];
					[currentEditComponent setNextMovementIndicatorEntity:movementIndicator];
					currentEditComponent = (EditComponent *)[movementIndicator getComponent:[EditComponent class]];
				}
			}
			else
			{
				// Load movement points normally
				entity = [EntityFactory createLeaf:world withMovePositions:[levelLayoutEntry movePositions]];
			}
		}

		NSAssert(entity != nil, @"Unrecognized level layout entry type: %@", [levelLayoutEntry type]);
		
		if (entity != nil)
		{
			[EntityUtil setEntityPosition:entity position:[levelLayoutEntry position]];
			[EntityUtil setEntityRotation:entity rotation:[levelLayoutEntry rotation]];
			[EntityUtil setEntityMirrored:entity mirrored:[levelLayoutEntry mirrored]];
			
			if (CONFIG_CAN_EDIT_LEVELS)
			{
				[entity addComponent:editComponent];
				[entity refresh];
			}
		}
    }
}

@end

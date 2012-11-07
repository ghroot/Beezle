//
//  LevelSerializer.m
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSerializer.h"
#import "EditComponent.h"
#import "EntityUtil.h"
#import "LevelLayout.h"
#import "LevelLayoutEntry.h"

static const int LEVEL_LAYOUT_FORMAT = 2;

@interface LevelSerializer()

-(BOOL) isLevelLayoutEntity:(Entity *)entity;
-(BOOL) hasInstanceComponentDictAnyValues:(NSDictionary *)instanceComponentDict;

@end

@implementation LevelSerializer

+(LevelSerializer *) sharedSerializer
{
    static LevelSerializer *serializer = 0;
    if (!serializer)
    {
        serializer = [[self alloc] init];
    }
    return serializer;
}

-(LevelLayout *) layoutFromDictionary:(NSDictionary *)dict
{
	int format;
	if ([dict objectForKey:@"format"] != nil)
	{
		format = [[dict objectForKey:@"format"] intValue];
	}
	else
	{
		format = 1;
	}
	NSString *levelName = [dict objectForKey:@"name"];
	
	if (format < LEVEL_LAYOUT_FORMAT)
	{
		NSLog(@"Unsupported level layout format: %@ (format: %d < %d)", levelName, format, LEVEL_LAYOUT_FORMAT);
		return nil;
	}
	
	LevelLayout *levelLayout = [LevelLayout layout];
	
	[levelLayout setFormat:format];
	[levelLayout setLevelName:levelName];
	
	int version = [[dict objectForKey:@"version"] intValue];
	[levelLayout setVersion:version];

	[levelLayout setPollenForTwoFlowers:[[dict objectForKey:@"pollenForTwoFlowers"] intValue]];
	[levelLayout setPollenForThreeFlowers:[[dict objectForKey:@"pollenForThreeFlowers"] intValue]];

	[levelLayout setHasWater:[[dict objectForKey:@"hasWater"] boolValue]];

	NSArray *entities = [dict objectForKey:@"entities"];
	for (NSDictionary *entity in entities) 
	{
		LevelLayoutEntry *levelLayoutEntry = [LevelLayoutEntry entry];
		
		NSString *type = [entity objectForKey:@"type"];
		NSDictionary *instanceComponentsDict = [entity objectForKey:@"components"];

		// TEMP: Ignore GLASS and ICE with override values that don't exist
//		if (([type hasPrefix:@"GLASS-"] && [type length] == 7) ||
//			[type isEqualToString:@"ICE"])
//		{
//			EntityDescription *entityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:type];
//
//			// Missing physics body
//			NSDictionary *physicsTypeComponentDict = [[entityDescription typeComponentsDict] objectForKey:@"physics"];
//			NSString *shapesFileName = [physicsTypeComponentDict objectForKey:@"file"];
//			[[GCpShapeCache sharedShapeCache] addShapesWithFile:shapesFileName];
//			NSDictionary *physicsInstanceComponentDict = [instanceComponentsDict objectForKey:@"physics"];
//			NSString *overrideBodyName = [physicsInstanceComponentDict objectForKey:@"overrideBodyName"];
//			if (overrideBodyName != nil &&
//				[[GCpShapeCache sharedShapeCache] createBodyWithName:overrideBodyName] == nil)
//			{
//				continue;
//			}
//
//			// Missing image
//			NSDictionary *renderInstanceComponentDict = [instanceComponentsDict objectForKey:@"render"];
//			NSString *overrideTextureFileName = [renderInstanceComponentDict objectForKey:@"overrideTextureFile"];
//			if (overrideTextureFileName != nil &&
//				[CCSprite spriteWithFile:overrideTextureFileName] == nil)
//			{
//				continue;
//			}
//		}

		// TEMP: Ignore CLIRR with missing animations
//		if ([type isEqualToString:@"CLIRR"])
//		{
//			EntityDescription *entityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:type];
//			NSDictionary *renderTypeComponentDict = [[entityDescription typeComponentsDict] objectForKey:@"render"];
//			NSArray *sprites = [renderTypeComponentDict objectForKey:@"sprites"];
//			NSString *animationFileName = [[sprites objectAtIndex:0] objectForKey:@"animationFile"];
//			NSString *animationFilePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:animationFileName];
//			NSDictionary *animationsDict = [[NSDictionary dictionaryWithContentsOfFile:animationFilePath] objectForKey:@"animations"];
//
//			NSDictionary *renderInstanceComponentDict = [instanceComponentsDict objectForKey:@"render"];
//			NSString *overrideIdleAnimationName = [renderInstanceComponentDict objectForKey:@"overrideIdleAnimation"];
//
//			NSDictionary *animationDict = [animationsDict objectForKey:overrideIdleAnimationName];
//			if (animationDict != nil)
//			{
//				NSString *sheetFilename = @"C.plist";
//				NSString *sheetFilePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:sheetFilename];
//				NSDictionary *sheetDict = [NSDictionary dictionaryWithContentsOfFile:sheetFilePath];
//				NSDictionary *framesDict = [sheetDict objectForKey:@"frames"];
//
//				NSString *frameName = [[animationDict objectForKey:@"frames"] objectAtIndex:0];
//
//				if ([framesDict objectForKey:frameName] == nil)
//				{
//					continue;
//				}
//			}
//			else
//			{
//				continue;
//			}
//		}

		// TEMP: Ignore SMOKE particle
		if ([type isEqualToString:@"SMOKE"])
		{
			continue;
		}

		[levelLayoutEntry setType:[NSString stringWithString:type]];
		[levelLayoutEntry setInstanceComponentsDict:instanceComponentsDict];
		
		[levelLayout addLevelLayoutEntry:levelLayoutEntry];
	}
	
	return levelLayout;
}
 
-(NSDictionary *) dictionaryFromLayout:(LevelLayout *)layout
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	[dict setObject:[layout levelName] forKey:@"name"];
	[dict setObject:[NSNumber numberWithInt:[layout version]] forKey:@"version"];
	[dict setObject:[NSNumber numberWithInt:[layout format]] forKey:@"format"];

	[dict setObject:[NSNumber numberWithInt:[layout pollenForTwoFlowers]] forKey:@"pollenForTwoFlowers"];
	[dict setObject:[NSNumber numberWithInt:[layout pollenForThreeFlowers]] forKey:@"pollenForThreeFlowers"];

	[dict setObject:[NSNumber numberWithBool:[layout hasWater]] forKey:@"hasWater"];
	
	NSMutableArray *entities = [NSMutableArray array];
	for (LevelLayoutEntry *levelLayoutEntry in [layout entries])
	{
		NSMutableDictionary *entity = [NSMutableDictionary dictionary];
		[entity setObject:[levelLayoutEntry type] forKey:@"type"];
		[entity setObject:[levelLayoutEntry instanceComponentsDict] forKey:@"components"];
		[entities addObject:entity];
	}
	[dict setObject:entities forKey:@"entities"];
	
	return dict;
}

-(LevelLayout *) layoutFromWorld:(World *)world levelName:(NSString *)levelName version:(int)version
{
	LevelLayout *levelLayout = [LevelLayout layout];
	
	[levelLayout setLevelName:levelName];
	[levelLayout setVersion:version];
    [levelLayout setFormat:LEVEL_LAYOUT_FORMAT];
	
	[levelLayout setHasWater:[EntityUtil hasWaterEntity:world]];
	
	for (Entity *entity in [[world entityManager] entities])
	{
		if ([self isLevelLayoutEntity:entity])
		{
			LevelLayoutEntry *levelLayoutEntry = [[[LevelLayoutEntry alloc] init] autorelease];
			
			EditComponent *editComponent = [EditComponent getFrom:entity];
			[levelLayoutEntry setType:[editComponent levelLayoutType]];
			
			NSMutableDictionary *instanceComponentsDict = [NSMutableDictionary dictionary];
			NSArray *components = [entity getComponents];
			for (Component *component in components)
			{
				NSDictionary *instanceComponentDict = [component getInstanceComponentDict];
				if ([self hasInstanceComponentDictAnyValues:instanceComponentDict])
				{
                    NSString *componentClassName = NSStringFromClass([component class]);
                    NSString *componentName = [[componentClassName stringByReplacingOccurrencesOfString:@"Component" withString:@""] lowercaseString];
					[instanceComponentsDict setObject:instanceComponentDict forKey:componentName];
				}
			}
			[levelLayoutEntry setInstanceComponentsDict:instanceComponentsDict];
						
			[levelLayout addLevelLayoutEntry:levelLayoutEntry];
		}
	}
	
	return levelLayout;
}

-(BOOL) isLevelLayoutEntity:(Entity *)entity
{
	if ([entity hasComponent:[EditComponent class]])
	{
		EditComponent *editComponent = (EditComponent *)[entity getComponent:[EditComponent class]];
		if ([editComponent levelLayoutType] != nil)
		{
			return TRUE;
		}
	}
	return FALSE;
}

-(BOOL) hasInstanceComponentDictAnyValues:(NSDictionary *)instanceComponentDict
{
    // TODO: Check all sub collections
    return instanceComponentDict != nil &&
        [instanceComponentDict count] > 0;
}

@end

//
//  EntitySelectIngameMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntitySelectIngameMenuState.h"
#import "EditState.h"
#import "EntityDescription.h"
#import "Game.h"
#import "LevelOrganizer.h"
#import "EntityDescriptionCache.h"
#import "EntitySelectMenuItem.h"

@interface EntitySelectIngameMenuState()

-(void) createEntityMenuItems:(NSArray *)entityTypes;
-(void) addMenuItemForEntityType:(NSString *)entityType;
-(void) addEntity:(id)sender;
-(void) addGlassEntities:(EditState *)editState;
-(void) addIceEntities:(EditState *)editState;
-(NSArray *) generateImageAndBodyNamesWithBaseName:(NSString *)baseName levelName:(NSString *)levelName;
-(void) addClirrEntities:(EditState *)editState;
-(NSArray *) generateClirrImageNamesForLevelName:(NSString *)levelName;
-(NSArray *) getAllClirrAnimationNames;
-(NSString *) convertToThemeSpecificEntityType:(NSString *)entityType levelName:(NSString *)levelName;
-(void) goBack:(id)sender;

@end

@implementation EntitySelectIngameMenuState

-(id) initWithEntityTypes:(NSArray *)entityTypes
{
	if (self = [super init])
	{
		_menu = [CCMenu menuWithItems:nil];
		
		[self createEntityMenuItems:entityTypes];
		
		CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
		[backMenuItem setFontSize:24];
		[_menu addChild:backMenuItem];

		int nMenuItems = [[_menu  children] count];
		int num1 = (int)ceilf(nMenuItems / 2.0f);
		int num2 = nMenuItems - num1;
		[_menu alignItemsInRows:[NSNumber numberWithInt:num1], [NSNumber numberWithInt:num2], nil];

		[self addChild:_menu];
        
        _alphabet = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", nil];
	}
    return self;
}

-(void) dealloc
{
    [_alphabet release];
    
    [super dealloc];
}

-(void) createEntityMenuItems:(NSArray *)entityTypes
{
	for (NSString *entityType in entityTypes)
	{
		[self addMenuItemForEntityType:entityType];
	}
}

-(void) addMenuItemForEntityType:(NSString *)entityType
{
	EntitySelectMenuItem *menuItem = [[[EntitySelectMenuItem alloc] initWithEntityType:entityType target:self selector:@selector(addEntity:)] autorelease];
	[menuItem setFontSize:26];
	[menuItem setUserData:entityType];
	[_menu addChild:menuItem];
}

-(void) addEntity:(id)sender
{
	CCMenuItem *menuItem = sender;
	NSString *entityType = [menuItem userData];
	
	[_game popState];
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	
	if ([entityType isEqualToString:@"GLASS"])
	{
		[self addGlassEntities:editState];
	}
	else if ([entityType isEqualToString:@"ICE"])
	{
		[self addIceEntities:editState];
	}
	else if ([entityType isEqualToString:@"CLIRR"])
	{
		[self addClirrEntities:editState];
	}
	else
	{
		if ([entityType isEqualToString:@"BEEATER-LAND"] ||
			[entityType isEqualToString:@"BEEATER-HANGING"] ||
			[entityType isEqualToString:@"BEEATER-BIRD"] ||
			[entityType isEqualToString:@"BEEATER-FISH"] ||
			[entityType isEqualToString:@"HANGNEST"] ||
			[entityType isEqualToString:@"RAMP"])
		{
			entityType = [self convertToThemeSpecificEntityType:entityType levelName:[editState levelName]];
		}
		[editState addEntityWithType:entityType];
	}
}

-(void) addGlassEntities:(EditState *)editState
{
    NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:[editState levelName]];
    NSString *glassEntityType = [NSString stringWithFormat:@"GLASS-%@", theme];
    NSArray *glassImageAndBodyNames = [self generateImageAndBodyNamesWithBaseName:@"Glass" levelName:[editState levelName]];
    for (NSArray *glassImageAndBodyName in glassImageAndBodyNames)
    {
        NSString *imageName = [glassImageAndBodyName objectAtIndex:0];
        NSString *bodyName = [glassImageAndBodyName objectAtIndex:1];
        
        NSMutableDictionary *instanceComponentsDict = [NSMutableDictionary dictionary];
		
		NSMutableDictionary *renderInstanceComponentDict = [NSMutableDictionary dictionary];
		[renderInstanceComponentDict setObject:imageName forKey:@"overrideTextureFile"];
		[instanceComponentsDict setObject:renderInstanceComponentDict forKey:@"render"];
		
		NSMutableDictionary *physicsInstanceComponentDict = [NSMutableDictionary dictionary];
		[physicsInstanceComponentDict setObject:bodyName forKey:@"overrideBodyName"];
		[instanceComponentsDict setObject:physicsInstanceComponentDict forKey:@"physics"];
		
		[editState addEntityWithType:glassEntityType instanceComponentsDict:instanceComponentsDict];
    }
}

-(void) addIceEntities:(EditState *)editState
{
    NSString *iceEntityType = @"ICE";
    NSArray *iceImageAndBodyNames = [self generateImageAndBodyNamesWithBaseName:@"Ice" levelName:[editState levelName]];
    for (NSArray *iceImageAndBodyName in iceImageAndBodyNames)
    {
        NSString *imageName = [iceImageAndBodyName objectAtIndex:0];
        NSString *bodyName = [iceImageAndBodyName objectAtIndex:1];
        
        NSMutableDictionary *instanceComponentsDict = [NSMutableDictionary dictionary];
		
		NSMutableDictionary *renderInstanceComponentDict = [NSMutableDictionary dictionary];
		[renderInstanceComponentDict setObject:imageName forKey:@"overrideTextureFile"];
		[instanceComponentsDict setObject:renderInstanceComponentDict forKey:@"render"];
		
		NSMutableDictionary *physicsInstanceComponentDict = [NSMutableDictionary dictionary];
		[physicsInstanceComponentDict setObject:bodyName forKey:@"overrideBodyName"];
		[instanceComponentsDict setObject:physicsInstanceComponentDict forKey:@"physics"];
		
		[editState addEntityWithType:iceEntityType instanceComponentsDict:instanceComponentsDict];
    }
}

-(NSArray *) generateImageAndBodyNamesWithBaseName:(NSString *)baseName levelName:(NSString *)levelName
{
    NSString *levelSuffix = [[levelName componentsSeparatedByString:@"-"] objectAtIndex:1];
    NSMutableArray *imageAndBodyNames = [NSMutableArray array];
    NSString *imageFileName = [NSString stringWithFormat:@"%@-%@.png", levelSuffix, baseName];
	if ([CCSprite spriteWithFile:imageFileName] != nil)
	{
        NSString *bodyName = [NSString stringWithFormat:@"%@-%@", levelSuffix, baseName];
        NSArray *imageAndBodyName = [NSArray arrayWithObjects:imageFileName, bodyName, nil];
        [imageAndBodyNames addObject:imageAndBodyName];
	}
	else
	{
		int i = 0;
		while (TRUE)
		{
			imageFileName = [NSString stringWithFormat:@"%@%@-%@.png", levelSuffix, [_alphabet objectAtIndex:i], baseName];
			if ([CCSprite spriteWithFile:imageFileName] != nil)
			{
                NSString *bodyName = [NSString stringWithFormat:@"%@%@-%@", levelSuffix, [_alphabet objectAtIndex:i], baseName];
                NSArray *imageAndBodyName = [NSArray arrayWithObjects:imageFileName, bodyName, nil];
                [imageAndBodyNames addObject:imageAndBodyName];
                i++;
			}
			else
			{
				break;
			}
		}
	}
    return imageAndBodyNames;
}

-(void) addClirrEntities:(EditState *)editState;
{
    NSString *clirrEntityType = @"CLIRR";
    NSArray *clirrAnimationNames = [self generateClirrImageNamesForLevelName:[editState levelName]];
    for (NSString *clirrAnimationName in clirrAnimationNames)
    {
        NSMutableDictionary *instanceComponentsDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *renderInstanceComponentDict = [NSMutableDictionary dictionary];
        [renderInstanceComponentDict setObject:clirrAnimationName forKey:@"overrideIdleAnimation"];
        [instanceComponentsDict setObject:renderInstanceComponentDict forKey:@"render"];
        
        [editState addEntityWithType:clirrEntityType instanceComponentsDict:instanceComponentsDict];
    }
}

-(NSArray *) generateClirrImageNamesForLevelName:(NSString *)levelName
{
    NSString *levelSuffix = [[levelName componentsSeparatedByString:@"-"] objectAtIndex:1];
    NSArray *allClirrAnimationNames = [self getAllClirrAnimationNames];
    NSMutableArray *clirrAnimationNamesForLevelName = [NSMutableArray array];
    int i = 1;
	while (TRUE)
	{
		NSString *clirrAnimationName = [NSString stringWithFormat:@"%@-Clirr-%d", levelSuffix, i++];
		if ([allClirrAnimationNames containsObject:clirrAnimationName])
		{
			[clirrAnimationNamesForLevelName addObject:clirrAnimationName];
		}
		else
		{
			i = 1;
			int j = 1;
			BOOL atLeastOneAnimationForThisI = FALSE;
			while (TRUE)
			{
				clirrAnimationName = [NSString stringWithFormat:@"%@-Clirr-%d-%d", levelSuffix, i, j++];
				if ([allClirrAnimationNames containsObject:clirrAnimationName])
				{
					[clirrAnimationNamesForLevelName addObject:clirrAnimationName];
					atLeastOneAnimationForThisI = TRUE;
				}
				else
				{
					if (atLeastOneAnimationForThisI)
					{
						atLeastOneAnimationForThisI = FALSE;
						i++;
						j = 1;
					}
					else
					{
						break;
					}
				}
			}
			
			break;
		}
	}
    return clirrAnimationNamesForLevelName;
}

-(NSArray *) getAllClirrAnimationNames
{
	EntityDescription *clirrEntityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:@"CLIRR"];
	NSDictionary *clirrRenderComponentDict = [[clirrEntityDescription typeComponentsDict] objectForKey:@"render"];
	NSDictionary *clirrRenderSpriteDict = [[clirrRenderComponentDict objectForKey:@"sprites"] lastObject];
	NSString *clirrAnimationsFile = [clirrRenderSpriteDict objectForKey:@"animationFile"];
	NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:clirrAnimationsFile];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
	NSDictionary *animationsDict = [dict objectForKey:@"animations"];
	NSMutableArray *clirrAnimationNames = [NSMutableArray array];
	for (NSString *animationName in [animationsDict allKeys])
	{
		[clirrAnimationNames addObject:animationName];
	}
    return clirrAnimationNames;
}

-(NSString *) convertToThemeSpecificEntityType:(NSString *)entityType levelName:(NSString *)levelName
{
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:levelName];
	return [entityType stringByAppendingFormat:@"-%@", theme];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end

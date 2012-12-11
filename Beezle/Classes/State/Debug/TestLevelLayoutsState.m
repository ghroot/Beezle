//
// Created by Marcus on 03/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TestLevelLayoutsState.h"
#import "Game.h"
#import "LevelOrganizer.h"
#import "LevelSerializer.h"
#import "LevelLoader.h"
#import "RenderSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"

@interface TestLevelLayoutsState()

-(NSString *) createString;

@end

@implementation TestLevelLayoutsState

-(id) init
{
	if (self = [super init])
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGSize labelSize = CGSizeMake(winSize.width, winSize.height - 30.0f);
		_label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:14 dimensions:labelSize hAlignment:kCCTextAlignmentLeft];
		[_label setAnchorPoint:CGPointMake(0.0f, 1.0f)];
		[_label setPosition:CGPointMake(0.0f, winSize.height)];
		[self addChild:_label];

		CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
			[_game popState];
		}];
		[backMenuItem setAnchorPoint:CGPointZero];
		[backMenuItem setPosition:CGPointZero];
		[backMenuItem setFontSize:20];
		CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
		[backMenu setPosition:CGPointZero];
		[self addChild:backMenu];

		_needsLoadingState = TRUE;
	}
	return self;
}

-(void) initialise
{
	[super initialise];

	[_label setString:[self createString]];
}

-(NSString *) createString
{
	NSMutableArray *lines = [NSMutableArray array];

	for (NSString *levelName in [[LevelOrganizer sharedOrganizer] allLevelNames])
	{
		World *world = [[[World alloc] init] autorelease];
		RenderSystem *renderSystem = [[[RenderSystem alloc] initWithLayer:[CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)]] autorelease];
		[[world systemManager] setSystem:renderSystem];
		PhysicsSystem *physicsSystem = [[[PhysicsSystem alloc] init] autorelease];
		[[world systemManager] setSystem:physicsSystem];
		[[LevelLoader sharedLoader] loadLevel:levelName inWorld:world edit:FALSE];

		for (Entity *entity in [[world entityManager] entities])
		{
			RenderComponent *renderComponent = [RenderComponent getFrom:entity];
			if (renderComponent != nil)
			{
				for (RenderSprite *renderSprite in [renderComponent renderSprites])
				{
					if ([renderSprite sprite] == nil)
					{
						[lines addObject:[NSString stringWithFormat:@"Found render error in %@", levelName]];
					}
				}
			}

			PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
			if (physicsComponent != nil)
			{
				if ([physicsComponent body] == nil)
				{
					[lines addObject:[NSString stringWithFormat:@"Found physics error in %@", levelName]];
				}
			}
		}

		int numberOfThemeSpriteSheets = 0;
		if ([[renderSystem spriteSheetsByName] objectForKey:@"A"] != nil)
		{
			numberOfThemeSpriteSheets++;
		}
		if ([[renderSystem spriteSheetsByName] objectForKey:@"B"] != nil)
		{
			numberOfThemeSpriteSheets++;
		}
		if ([[renderSystem spriteSheetsByName] objectForKey:@"C"] != nil)
		{
			numberOfThemeSpriteSheets++;
		}
		if ([[renderSystem spriteSheetsByName] objectForKey:@"D"] != nil)
		{
			numberOfThemeSpriteSheets++;
		}
		if (numberOfThemeSpriteSheets > 1)
		{
			[lines addObject:[NSString stringWithFormat:@"Found render error in %@", levelName]];
		}

		int numberOfBossThemeSpriteSheets = 0;
		if ([[renderSystem spriteSheetsByName] objectForKey:@"Boss-A"] != nil)
		{
			numberOfBossThemeSpriteSheets++;
		}
		if ([[renderSystem spriteSheetsByName] objectForKey:@"Boss-B"] != nil)
		{
			numberOfBossThemeSpriteSheets++;
		}
		if ([[renderSystem spriteSheetsByName] objectForKey:@"Boss-C"] != nil)
		{
			numberOfBossThemeSpriteSheets++;
		}
		if ([[renderSystem spriteSheetsByName] objectForKey:@"Boss-D"] != nil)
		{
			numberOfBossThemeSpriteSheets++;
		}
		if (numberOfBossThemeSpriteSheets > 1)
		{
			[lines addObject:[NSString stringWithFormat:@"Found render error in %@", levelName]];
		}

		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		if ([levelLayout pollenForTwoFlowers] == 0 ||
				[levelLayout pollenForThreeFlowers] == 0 ||
				[levelLayout pollenForThreeFlowers] <= [levelLayout pollenForTwoFlowers])
		{
			[lines addObject:[NSString stringWithFormat:@"Found pollen requirement error in %@", levelName]];
		}
	}

	NSMutableString *string = [NSMutableString string];
	if ([lines count] > 0)
	{
		for (NSString *line in lines)
		{
			[string appendFormat:@"%@\n", line];
		}
	}
	else
	{
		[string appendString:@"No errors found!\n"];
	}
	return string;
}

@end
//
// Created by Marcus on 21/04/2013.
//

#import <CoreGraphics/CoreGraphics.h>
#import "TestVisualState.h"
#import "RenderSystem.h"
#import "PhysicsSystem.h"
#import "LevelLoader.h"
#import "DebugRenderPhysicsSystem.h"
#import "LevelOrganizer.h"
#import "Game.h"

@implementation TestVisualState

+(TestVisualState *) stateWithLevelName:(NSString *)levelName
{
	return [[[self alloc] initWithLevelName:levelName] autorelease];
}

-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
	{
		_levelName = [levelName copy];

		_gameLayer = [CCLayer node];
		[self addChild:_gameLayer];

		CCLabelTTF *levelNameLabel = [CCLabelTTF labelWithString:_levelName fontName:@"Marker Felt" fontSize:16];
		[levelNameLabel setAnchorPoint:CGPointZero];
		[levelNameLabel setPosition:CGPointMake(2.0f, 2.0f)];
		[self addChild:levelNameLabel];

		_world = [[World alloc] init];
		SystemManager *systemManager = [_world systemManager];
		_physicsSystem = [PhysicsSystem system];
		[systemManager setSystem:_physicsSystem];
		_renderSystem = [[[RenderSystem alloc] initWithLayer:_gameLayer] autorelease];
		[_renderSystem setDisableSpriteSheetUnloading:TRUE];
		[systemManager setSystem:_renderSystem];
		_debugRenderPhysicsSystem = [[[DebugRenderPhysicsSystem alloc] initWithScene:self] autorelease];
		[systemManager setSystem:_debugRenderPhysicsSystem];
		[systemManager initialiseAll];

		[[LevelLoader sharedLoader] loadLevel:_levelName inWorld:_world edit:FALSE];
	}
	return self;
}

-(id) init
{
	return [self initWithLevelName:@"Level-A1"];
}

-(void) dealloc
{
	[_levelName release];
	[_world release];

	[super dealloc];
}

-(void) update:(ccTime)delta
{
	[_world loopStart];
	[_world setDelta:(int)(1000.0f * delta)];

	[[_world systemManager] processAll];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	if (convertedLocation.x < 30.0f &&
			convertedLocation.y > winSize.height - 30.0f)
	{
		[_game popState];
	}
	else if (convertedLocation.x < winSize.width / 2)
	{
		NSString *levelNameBefore = [[LevelOrganizer sharedOrganizer] levelNameBefore:_levelName];
		if (levelNameBefore != nil)
		{
			[_game replaceState:[TestVisualState stateWithLevelName:levelNameBefore]];
		}
		else
		{
			NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:_levelName];
			NSString *themeBefore = [[LevelOrganizer sharedOrganizer] themeBefore:theme];
			if (themeBefore != nil)
			{
				NSString *lastLevelNameInThemeBefore = [[[LevelOrganizer sharedOrganizer] levelNamesInTheme:themeBefore] lastObject];
				[_game replaceState:[TestVisualState stateWithLevelName:lastLevelNameInThemeBefore]];
			}
		}
	}
	else
	{
		NSString *levelNameAfter = [[LevelOrganizer sharedOrganizer] levelNameAfter:_levelName];
		if (levelNameAfter != nil)
		{
			[_game replaceState:[TestVisualState stateWithLevelName:levelNameAfter]];
		}
		else
		{
			NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:_levelName];
			NSString *themeAfter = [[LevelOrganizer sharedOrganizer] themeAfter:theme];
			if (themeAfter != nil)
			{
				NSString *firstLevelNameInThemeAfter = [[[LevelOrganizer sharedOrganizer] levelNamesInTheme:themeAfter] objectAtIndex:0];
				[_game replaceState:[TestVisualState stateWithLevelName:firstLevelNameInThemeAfter]];
			}
		}
	}

	return TRUE;
}

@end

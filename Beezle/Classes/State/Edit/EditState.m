//
//  EditState.m
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditState.h"
#import "BeeaterSystem.h"
#import "BeeQueueRenderingSystem.h"
#import "DebugRenderPhysicsSystem.h"
#import "DisposableComponent.h"
#import "EditComponent.h"
#import "EditControlSystem.h"
#import "EditIngameMenuState.h"
#import "EditOptionsSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "Game.h"
#import "InputSystem.h"
#import "LabelManager.h"
#import "LevelLoader.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"

@interface EditState()

-(void) createUI;
-(void) createWorldAndSystems;

@end

@implementation EditState

@synthesize levelName = _levelName;
@synthesize world = _world;

+(id) stateWithLevelName:(NSString *)levelName
{
	return [[[self alloc] initWithLevelName:levelName] autorelease];
}

// Designated initialiser
-(id) initWithLevelName:(NSString *)levelName
{
    if (self = [super init])
    {
		_levelName = [levelName retain];
		
		_gameLayer = [CCLayer node];
		[self addChild:_gameLayer];
		
		[self createUI];
		[self createWorldAndSystems];
		[[LevelLoader sharedLoader] loadLevel:_levelName inWorld:_world edit:TRUE];
    }
    return self;
}

-(id) init
{
	return [self initWithLevelName:nil];
}

-(void) createUI
{
    _uiLayer = [CCLayer node];
    [self addChild:_uiLayer];
    
    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"PauseArrow-01.png" selectedImage:@"PauseArrow-01.png" target:self selector:@selector(pauseGame:)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [pauseMenuItem setPosition:CGPointMake(winSize.width - 2.0f, winSize.height - 2.0f)];
    [pauseMenuItem setAnchorPoint:CGPointMake(1.0f, 1.0f)];
    CCMenu *menu = [CCMenu menuWithItems:pauseMenuItem, nil];
    [menu setPosition:CGPointZero];
    [_uiLayer addChild:menu];
}

-(void) createWorldAndSystems
{	
    _world = [[World alloc] init];
    
	SystemManager *systemManager = [_world systemManager];
	
	_renderSystem = [[[RenderSystem alloc] initWithLayer:_gameLayer] autorelease];
	[systemManager setSystem:_renderSystem];
	_physicsSystem = [[[PhysicsSystem alloc] init] autorelease];
	[systemManager setSystem:_physicsSystem];
	_inputSystem = [[[InputSystem alloc] init] autorelease];
	[systemManager setSystem:_inputSystem];
	_editControlSystem = [[[EditControlSystem alloc] init] autorelease];
	[systemManager setSystem:_editControlSystem];
	_editOptionsSystem = [[[EditOptionsSystem alloc] initWithLayer:_uiLayer andEditState:self] autorelease];
	[systemManager setSystem:_editOptionsSystem];
	_beeQueueRenderingSystem = [[[BeeQueueRenderingSystem alloc] initWithZ:2] autorelease];
	[systemManager setSystem:_beeQueueRenderingSystem];
	_beeaterSystem = [[[BeeaterSystem alloc] init] autorelease];
	[systemManager setSystem:_beeaterSystem];
	_debugRenderPhysicsSystem = [[[DebugRenderPhysicsSystem alloc] initWithScene:self] autorelease];
	[systemManager setSystem:_debugRenderPhysicsSystem];
	[_debugRenderPhysicsSystem deactivate];
	
	[systemManager initialiseAll];
}

-(void) dealloc
{	
	[_levelName release];
    [_world release];
	
	[super dealloc];
}

-(void) enter
{
    [super enter];
    
    [_inputSystem activate];
}

-(void) leave
{
    [_inputSystem deactivate];
    
    [super leave];
}

-(void) update:(ccTime)delta
{
	[_world loopStart];
	[_world setDelta:(1000.0f * delta)];
    
	[[_world systemManager] processAll];
}

-(Entity *) addEntityWithType:(NSString *)type instanceComponentsDict:(NSDictionary *)instanceComponentsDict
{	
	Entity *entity = [EntityFactory createEntity:type world:_world instanceComponentsDict:instanceComponentsDict edit:TRUE];
	if (entity != nil)
	{
		[entity addComponent:[EditComponent componentWithLevelLayoutType:type]];
		[entity refresh];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[EntityUtil setEntityPosition:entity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
		
		[_editControlSystem selectEntity:entity];
	}
	return entity;
}

-(Entity *) addEntityWithType:(NSString *)type
{
	return [self addEntityWithType:type instanceComponentsDict:nil];
}

-(void) toggleDebugPhysicsDrawing
{
	if ([_debugRenderPhysicsSystem active])
	{
		[_debugRenderPhysicsSystem deactivate];
	}
	else
	{
		[_debugRenderPhysicsSystem activate];
	}
}

-(void) pauseGame:(id)sender
{
	[_game pushState:[EditIngameMenuState state]];
}

@end

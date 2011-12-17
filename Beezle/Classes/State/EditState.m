//
//  EditState.m
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditState.h"
#import "DebugRenderPhysicsSystem.h"
#import "EditComponent.h"
#import "EditControlSystem.h"
#import "InputSystem.h"
#import "LevelLoader.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderSystem.h"

@interface EditState()

-(void) createWorldAndSystems;

@end

@implementation EditState

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
		
		[[CCDirector sharedDirector] setNeedClear:FALSE];
		
		_gameLayer = [CCLayer node];
		[self addChild:_gameLayer];
		
		[self createWorldAndSystems];
		[[LevelLoader loader] loadLevel:_levelName inWorld:_world];
		
		for (Entity *entity in [[_world entityManager] entities])
		{
			EditComponent *editComponent = [EditComponent component];
			[entity addComponent:editComponent];
			
			PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
			[physicsComponent disable];
			
			[entity refresh];
		}
    }
    return self;
}

-(id) init
{
	return [self initWithLevelName:nil];
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
	_debugRenderPhysicsSystem = [[[DebugRenderPhysicsSystem alloc] initWithScene:self] autorelease];
	[systemManager setSystem:_debugRenderPhysicsSystem];
	_editControlSystem = [[[EditControlSystem alloc] init] autorelease];
	[systemManager setSystem:_editControlSystem];
	
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

@end

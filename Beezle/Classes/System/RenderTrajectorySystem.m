//
//  RenderTrajectorySystem.m
//  Beezle
//
//  Created by Me on 08/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderTrajectorySystem.h"
#import "PhysicsSystem.h"
#import "RenderTrajectoryLayer.h"
#import "TrajectoryComponent.h"

@implementation RenderTrajectorySystem

// Designated initialiser
-(id) initWithScene:(CCScene *)scene
{
    if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TrajectoryComponent class], nil]])
    {
        _scene = scene;
		_renderTrajectoryLayer = [[RenderTrajectoryLayer alloc] init];
		[_scene addChild:_renderTrajectoryLayer];
    }
    return self;
}

-(id) init
{
	return [self initWithScene:nil];
}

-(void) dealloc
{
    [_scene removeChild:_renderTrajectoryLayer cleanup:TRUE];
    [_renderTrajectoryLayer release];
    
    [super dealloc];
}

-(void) entityAdded:(Entity *)entity
{
	PhysicsSystem *physicsSystem = [_world getSystem:[PhysicsSystem class]];
	
	[_renderTrajectoryLayer setGravity:cpSpaceGetGravity([physicsSystem space])];
}

-(void) processEntity:(Entity *)entity
{
	TrajectoryComponent *trajectoryComponent = [entity getComponent:[TrajectoryComponent class]];
	
	CGPoint startVelocity = CGPointMake(cosf([trajectoryComponent angle]) * [trajectoryComponent power], sinf([trajectoryComponent angle]) * [trajectoryComponent power]);
	
	[_renderTrajectoryLayer setStartPoint:[trajectoryComponent startPoint]];
	[_renderTrajectoryLayer setStartVelocity:startVelocity];
}

@end

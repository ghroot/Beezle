//
//  DebugRenderPhysicsSystem.m
//  Beezle
//
//  Created by Me on 20/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugRenderPhysicsSystem.h"
#import "DebugRenderPhysicsLayer.h"
#import "PhysicsComponent.h"

@implementation DebugRenderPhysicsSystem

-(id) initWithScene:(CCScene *)scene
{
    if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[PhysicsComponent class], nil]])
    {
        _scene = scene;
        _debugRenderPhysicsLayer = [[DebugRenderPhysicsLayer alloc] init];
        [_scene addChild:_debugRenderPhysicsLayer];
    }
    return self;
}

-(void) dealloc
{
    [_scene removeChild:_debugRenderPhysicsLayer cleanup:TRUE];
    [_debugRenderPhysicsLayer release];
    
    [super dealloc];
}

-(void) begin
{
    [[_debugRenderPhysicsLayer entitiesToDraw] removeAllObjects];
}

-(void) processEntity:(Entity *)entity
{
	[[_debugRenderPhysicsLayer entitiesToDraw] addObject:entity];
}

-(void) activate
{
	[super activate];
	[_scene addChild:_debugRenderPhysicsLayer];
}

-(void) deactivate
{
	[super deactivate];
	[_scene removeChild:_debugRenderPhysicsLayer cleanup:TRUE];
}

@end

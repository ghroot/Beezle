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
#import "PhysicsSystem.h"

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
    [[_debugRenderPhysicsLayer shapesToDraw] removeAllObjects];
}

-(void) processEntity:(Entity *)entity
{
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
    
    for (ChipmunkShape *shape in [physicsComponent shapes])
    {
        [[_debugRenderPhysicsLayer shapesToDraw] addObject:shape];
    }
}

@end

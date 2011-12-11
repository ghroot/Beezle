//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "BeeaterComponent.h"
#import "BeeComponent.h"
#import "BeeTypes.h"
#import "Collision.h"
#import "CollisionTypes.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SimpleAudioEngine.h"
#import "SlingerComponent.h"
#import "TagManager.h"
#import "TransformComponent.h"

@implementation CollisionSystem

-(id) init
{
    if (self = [super init])
    {
        _collisions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_collisions release];
    
    [super dealloc];
}

-(void) pushCollision:(Collision *)collision
{
    [_collisions addObject:collision];
}

-(void) initialise
{   
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_BACKGROUND];
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_BEEATER];
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_EDGE];
	[physicsSystem detectBeforeCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_POLLEN];
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_RAMP];
    [physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_MUSHROOM];
    [physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_WOOD];
    [physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_NUT];
    [physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_AIM_POLLEN and:COLLISION_TYPE_EDGE];
}

-(void) begin
{
    [self handleCollisions];
}

-(void) handleCollisions
{
    for (Collision *collision in _collisions)
    {
        PhysicsComponent *firstPhysicsComponent = (PhysicsComponent *)[[collision firstEntity] getComponent:[PhysicsComponent class]];
        PhysicsComponent *secondPhysicsComponent = (PhysicsComponent *)[[collision secondEntity] getComponent:[PhysicsComponent class]];
        
        if ([[firstPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_BEE)
        {
            if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_RAMP)
            {
                [self handleCollisionBee:[collision firstEntity] withRamp:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_BEEATER)
            {
                [self handleCollisionBee:[collision firstEntity] withBeeater:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_BACKGROUND)
            {
                [self handleCollisionBee:[collision firstEntity] withBackground:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_EDGE)
            {
                [self handleCollisionBee:[collision firstEntity] withEdge:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_POLLEN)
            {
                [self handleCollisionBee:[collision firstEntity] withPollen:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_MUSHROOM)
            {
                [self handleCollisionBee:[collision firstEntity] withMushroom:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_WOOD)
            {
                [self handleCollisionBee:[collision firstEntity] withWood:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_NUT)
            {
                [self handleCollisionBee:[collision firstEntity] withNut:[collision secondEntity]];
            }
        }
        else if ([[firstPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_AIM_POLLEN)
        {
            if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_EDGE)
            {
                [self handleCollisionAimPollen:[collision firstEntity] withEdge:[collision secondEntity]];
            }
        }
    }
    [_collisions removeAllObjects];    
}

-(void) handleCollisionBee:(Entity *)beeEntity withRamp:(Entity *)rampEntity
{
    BeeComponent *beeComponent = (BeeComponent *)[beeEntity getComponent:[BeeComponent class]];
    BeeTypes *beeType = [beeComponent type];
    
    if ([beeType canDestroyRamp])
    {
        // Bee is destroyed
        [beeEntity deleteEntity];
        
        // Crash animation (and delete entity at end of animation)
        RenderComponent *rampRenderComponent = (RenderComponent *)[rampEntity getComponent:[RenderComponent class]];
        [rampRenderComponent playAnimation:@"Ramp-Crash" withCallbackTarget:rampEntity andCallbackSelector:@selector(deleteEntity)];
        
        // Disable physics component
        PhysicsComponent *physicsComponent = (PhysicsComponent *)[rampEntity getComponent:[PhysicsComponent class]];
        [physicsComponent disable];
        [rampEntity refresh];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"52144__blaukreuz__imp-02.m4a"];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity
{   
	TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
	Entity *slingerEntity = (Entity *)[tagManager getEntity:@"SLINGER"];
	SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];

	BeeaterComponent *beeaterComponent = (BeeaterComponent *)[beeaterEntity getComponent:[BeeaterComponent class]];
    
    RenderComponent *beeaterRenderComponent = (RenderComponent *)[beeaterEntity getComponent:[RenderComponent class]];
    RenderSprite *beeaterBodyRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"body"];
	RenderSprite *beeaterHeadRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"head"];
    
    TransformComponent *beeaterTransformComponent = (TransformComponent *)[beeaterEntity getComponent:[TransformComponent class]];
    PhysicsComponent *beeaterPhysicsComponent = (PhysicsComponent *)[beeaterEntity getComponent:[PhysicsComponent class]];
    
    if ([beeaterComponent isKilled])
    {
        NSLog(@"WARNING: Beeater already killed, but still collided with!");
        return;
    }
    
    // Bee is destroyed
	[beeEntity deleteEntity];
    
    // Bee is freed
    [slingerComponent pushBeeType:[beeaterComponent containedBeeType]];
    
    // Beater is destroyed
    [beeaterTransformComponent setScale:CGPointMake(1.0f, 1.0f)];
    [beeaterHeadRenderSprite hide];
    [beeaterBodyRenderSprite playAnimation:@"Beeater-Body-Destroy" withCallbackTarget:beeaterEntity andCallbackSelector:@selector(deleteEntity)];
    [beeaterPhysicsComponent disable];
    [beeaterComponent setIsKilled:TRUE];
    [beeaterEntity refresh];
}

-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity
{
}

-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity
{
	// Remove bee
	[beeEntity deleteEntity];
}

-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity
{
    RenderComponent *pollenRenderComponent = (RenderComponent *)[pollenEntity getComponent:[RenderComponent class]];
	[pollenRenderComponent playAnimation:@"Pollen-Pickup" withCallbackTarget:pollenEntity andCallbackSelector:@selector(deleteEntity)];
    
    // Disable physics component
    PhysicsComponent *pollenPhysicsComponent = (PhysicsComponent *)[pollenEntity getComponent:[PhysicsComponent class]];
    [pollenPhysicsComponent disable];
    [pollenEntity refresh];
}

-(void)handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity
{
    RenderComponent *mushroomRenderComponent = (RenderComponent *)[mushroomEntity getComponent:[RenderComponent class]];
	[mushroomRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"11097__a43__a43-blipp.aif"];
}

-(void)handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity
{
    BeeComponent *beeComponent = (BeeComponent *)[beeEntity getComponent:[BeeComponent class]];
    BeeTypes *beeType = [beeComponent type];
    
    if ([beeType canDestroyWood])
    {
        [beeEntity deleteEntity];
        
        RenderComponent *woodRenderComponent = (RenderComponent *)[woodEntity getComponent:[RenderComponent class]];
        [woodRenderComponent playAnimation:@"Wood-Destroy" withCallbackTarget:woodEntity andCallbackSelector:@selector(deleteEntity)];
        
        // Disable physics component
        PhysicsComponent *woodPhysicsComponent = (PhysicsComponent *)[woodEntity getComponent:[PhysicsComponent class]];
        [woodPhysicsComponent disable];
        [woodEntity refresh];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withNut:(Entity *)nutEntity
{
    [beeEntity deleteEntity];
    
    RenderComponent *nutRenderComponent = (RenderComponent *)[nutEntity getComponent:[RenderComponent class]];
	[nutRenderComponent playAnimation:@"Nut-Collect" withCallbackTarget:nutEntity andCallbackSelector:@selector(deleteEntity)];
    
    // Disable physics component
    PhysicsComponent *nutPhysicsComponent = (PhysicsComponent *)[nutEntity getComponent:[PhysicsComponent class]];
    [nutPhysicsComponent disable];
    [nutEntity refresh];
}

-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity
{
    [aimPollenEntity deleteEntity];
}

@end

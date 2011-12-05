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
#import "Collision.h"
#import "CollisionTypes.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "SimpleAudioEngine.h"
#import "SlingerComponent.h"
#import "TagManager.h"

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
        }
    }
    [_collisions removeAllObjects];    
}

-(void) handleCollisionBee:(Entity *)beeEntity withRamp:(Entity *)rampEntity
{
    // Crash animation (and delete entity at end of animation)
    RenderComponent *rampRenderComponent = (RenderComponent *)[rampEntity getComponent:[RenderComponent class]];
    [rampRenderComponent playAnimation:@"Ramp-Crash" withCallbackTarget:rampEntity andCallbackSelector:@selector(deleteEntity)];
    
    // Disable physics component
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[rampEntity getComponent:[PhysicsComponent class]];
    [physicsComponent disable];
    [rampEntity refresh];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"52144__blaukreuz__imp-02.m4a"];
}

-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity
{
	TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
	Entity *slingerEntity = (Entity *)[tagManager getEntity:@"SLINGER"];
	SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];

	BeeaterComponent *beeaterComponent = (BeeaterComponent *)[beeaterEntity getComponent:[BeeaterComponent class]];
	BeeComponent *beeComponent = (BeeComponent *)[beeEntity getComponent:[BeeComponent class]];
    
    RenderComponent *beeaterRenderComponent = (RenderComponent *)[beeaterEntity getComponent:[RenderComponent class]];
	RenderSprite *headRenderSprite = (RenderSprite *)[[beeaterRenderComponent renderSprites] objectAtIndex:1];
    
	if ([beeaterComponent hasContainedBee])
	{
		// Bee is freed
		[slingerComponent pushBeeType:[beeaterComponent containedBeeType]];
		
		// Beater is destroyed
		[beeaterEntity deleteEntity];
        
        [headRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:@"Beeater-Head-Idle", @"Beeater-Head-Lick", nil]];
	}
	else
	{
		// Beeater eats bee
		[beeaterComponent setContainedBeeType:[beeComponent type]];
        
        [headRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:@"Beeater-Head-Idle", @"Beeater-Head-Show-Bee", nil]];
	}
	
	// Bee is destroyed
	[beeEntity deleteEntity];
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
    [pollenEntity deleteEntity];
}

-(void)handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity
{
    RenderComponent *mushroomRenderComponent = (RenderComponent *)[mushroomEntity getComponent:[RenderComponent class]];
	[mushroomRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"11097__a43__a43-blipp.aif"];
}

-(void)handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity
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

@end

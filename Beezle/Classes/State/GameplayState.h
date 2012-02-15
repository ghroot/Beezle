//
//  GameplayState.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"
#import "cocos2d.h"
#import "GameMode.h"

@class BeeaterAnimationSystem;
@class BeeExpiratonSystem;
@class ExplodeControlSystem;
@class BeeQueueRenderingSystem;
@class CollisionSystem;
@class DebugRenderPhysicsSystem;
@class GameRulesSystem;
@class InputSystem;
@class MovementSystem;
@class PhysicsSystem;
@class RenderSystem;
@class SlingerControlSystem;
@class TrailSystem;

@interface GameplayState : GameState
{
	NSString *_levelName;
	
	CCLayer *_gameLayer;
	CCLayer *_uiLayer;

	World *_world;
	
	BOOL _debug;
	
    GameRulesSystem *_gameRulesSystem;
    PhysicsSystem *_physicsSystem;
	MovementSystem *_movementSystem;
    CollisionSystem *_collisionSystem;
    RenderSystem *_renderSystem;
    InputSystem *_inputSystem;
    SlingerControlSystem *_slingerControlSystem;
    BeeExpiratonSystem *_beeExpirationSystem;
	ExplodeControlSystem *_explodeControlSystem;
	BeeQueueRenderingSystem *_beeQueueRenderingSystem;
	BeeaterAnimationSystem *_beeaterAnimationSystem;
	TrailSystem *_trailSystem;
	DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    
    GameMode *_currentMode;
    GameMode *_aimingMode;
    GameMode *_shootingMode;
    GameMode *_levelCompletedMode;
    GameMode *_levelFailedMode;
}

@property (nonatomic, readonly) NSString *levelName;

+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;
-(void) pauseGame:(id)sender;

@end

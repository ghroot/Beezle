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

@class BeeSystem;
@class BeeQueueRendering;
@class CollisionSystem;
@class DebugRenderPhysicsSystem;
@class GameRulesSystem;
@class InputSystem;
@class PhysicsSystem;
@class RenderSystem;
@class SlingerControlSystem;

@interface GameplayState : GameState
{
	NSString *_levelName;
	
	CCLayer *_gameLayer;
	CCLayer *_uiLayer;
	
	BeeQueueRendering *_beeQueueRendering;

	World *_world;
	
	BOOL _debug;
	
    GameRulesSystem *_gameRulesSystem;
    PhysicsSystem *_physicsSystem;
    CollisionSystem *_collisionSystem;
    RenderSystem *_renderSystem;
    DebugRenderPhysicsSystem *_debugRenderPhysicsSystem;
    InputSystem *_inputSystem;
    SlingerControlSystem *_slingerControlSystem;
    BeeSystem *_beeSystem;
    
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

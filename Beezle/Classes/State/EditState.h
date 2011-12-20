//
//  EditState.h
//  Beezle
//
//  Created by Me on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"

@class EditControlSystem;
@class EditOptionsSystem;
@class InputSystem;
@class RenderSystem;
@class PhysicsSystem;

@interface EditState : GameState
{
	NSString *_levelName;
	
	CCLayer *_gameLayer;
	CCLayer *_uiLayer;
	
	World *_world;
	
    RenderSystem *_renderSystem;
	PhysicsSystem *_physicsSystem;
    InputSystem *_inputSystem;
	EditControlSystem *_editControlSystem;
	EditOptionsSystem *_editOptionsSystem;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic, readonly) World *world;

+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;

-(void) pauseGame:(id)sender;

@end

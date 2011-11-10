//
//  HelloWorldLayer.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "SystemManager.h"
#import "World.h"

@class EntityManager;
@class InputSystem;

@interface GameLayer : CCLayer
{
    World *_world;
    InputSystem *_inputSystem;
    
    BOOL isTouching;
    CGPoint touchStartLocation;
    CGPoint touchVector;
    Entity *_staticEntity;
}

-(void) createEntityAtPosition:(CGPoint) position;

@end

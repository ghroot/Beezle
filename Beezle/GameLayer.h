//
//  HelloWorldLayer.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "AbstractSystem.h"

@class EntityManager;

@interface GameLayer : CCLayer
{
    EntityManager *entityManager;
    NSMutableArray *_systems;
    
    AbstractSystem *_transformSystem;
    AbstractSystem *_physicsSystem;
    AbstractSystem *_renderSystem;
    
    BOOL isTouching;
    CGPoint touchStartLocation;
    CGPoint touchVector;
    Entity *_staticEntity;
}

-(void) createEntityAtPosition:(CGPoint) position;

@end

//
//  HelloWorldLayer.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "chipmunk.h"
#import "cocos2d.h"

@class Actor;
@class TestActor;

@interface GameLayer : CCLayer
{
    cpSpace *_space; // strong ref
    
    NSMutableArray *_actors;
    TestActor *testActor;
    
    BOOL isTouching;
    CGPoint touchStartLocation;
    CGPoint touchVector;
}

-(cpSpace *) space;
-(void) initPhysics;
-(void) addActor:(Actor *)actor;
-(void) removeActor:(Actor *)actor;

@end

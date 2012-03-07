//
//  GameMode.h
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface GameMode : NSObject
{
    NSString *_name;
    
    BOOL(^_transitionBlock)(void);
    void(^_enterBlock)(void);
    
    NSArray *_systems;
    
    World *_world;
}

@property (nonatomic, copy) NSString *name;

+(GameMode *) mode;
+(GameMode *) modeWithSystems:(NSArray *)systems;

-(id) initWithSystems:(NSArray *)systems;

-(void) setTransitionBlock:(BOOL(^)(void))block;
-(BOOL) shouldTransition;
-(void) setEnterBlock:(void(^)(void))block;
-(void) processSystems;
-(void) enter;
-(void) leave;

-(id) initWithWorld:(World *)world;
-(GameMode *) nextMode;

@end

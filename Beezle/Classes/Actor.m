//
//  Actor.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Actor.h"

#import "GameLayer.h"

@implementation Actor

-(id) init
{
    if (self = [super init])
    {
        _behaviours = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addBehaviour:(AbstractBehaviour *)behaviour
{
    [_behaviours addObject:behaviour];
    behaviour.parentActor = self;
}

-(AbstractBehaviour *) getBehaviour:(NSString *)name
{
    AbstractBehaviour *behaviourToReturn;
    
    for (AbstractBehaviour *behaviour in _behaviours)
    {
        if ([[behaviour name] isEqualToString:name])
        {
            behaviourToReturn = behaviour;
            break;
        }
    }
    
    return behaviourToReturn;
}

-(BOOL) hasBehaviour:(NSString *)name
{
    return [self getBehaviour:name] != NULL;
}

-(void) addedToLayer:(GameLayer *)layer
{
    for (AbstractBehaviour *behaviour in _behaviours)
    {
        [behaviour addedToLayer:layer];
    }
}

-(void) removedFromLayer:(GameLayer *)layer
{
    for (AbstractBehaviour *behaviour in _behaviours)
    {
        [behaviour removedFromLayer:layer];
    }
}

-(void) setPosition:(CGPoint) position
{
    for (AbstractBehaviour *behaviour in _behaviours)
    {
        [behaviour setPosition:position];
    }
}

-(void) update:(ccTime) delta
{
    for (AbstractBehaviour *behaviour in _behaviours)
    {
        [behaviour update:delta];
    }
}

-(void) dealloc
{
    [_behaviours release];
    
    [super dealloc];
}

@end

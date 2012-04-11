//
//  CollisionHandler.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionMediator.h"

@implementation CollisionMediator

+(CollisionMediator *) mediatorWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 target:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithType1:type1 type2:type2 target:target selector:selector] autorelease];
}

-(id) initWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 target:(id)target selector:(SEL)selector
{
	if (self = [super init])
	{
		_type1 = type1;
		_type2 = type2;
        _target = target;
		_selector = selector;
	}
	return self;
}

-(BOOL) appliesForCollision:(Collision *)collision
{
    return _type1 == [collision firstCollisionType] && 
        _type2 == [collision secondCollisionType];
}

-(void) mediateCollision:(Collision *)collision
{
    Entity *firstEntity = [collision firstEntity];
    Entity *secondEntity = [collision secondEntity];
    
    NSMethodSignature *signature = [_target methodSignatureForSelector:_selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:_target];
    [invocation setSelector:_selector];
    [invocation setArgument:&firstEntity atIndex:2];
    [invocation setArgument:&secondEntity atIndex:3];
    [invocation setArgument:&collision atIndex:4];
    [invocation invoke];
}

@end

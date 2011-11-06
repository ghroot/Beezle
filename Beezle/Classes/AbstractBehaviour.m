//
//  AbstractBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractBehaviour.h"

#import "Actor.h"

@implementation AbstractBehaviour

@synthesize name = _name;
@synthesize parentActor = _parentActor;

- (id)init
{
    self = [super init];
    return self;
}

-(void) addedToLayer:(GameLayer *)layer
{
}

-(void) removedFromLayer:(GameLayer *)layer
{
}

-(void) setPosition:(CGPoint)position
{
}

-(void) update:(ccTime) delta
{
}

@end

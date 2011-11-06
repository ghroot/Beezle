//
//  RenderableBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderableBehaviour.h"

@implementation RenderableBehaviour

- (id)initWithSprite:(CCSprite *)sprite
{
    if (self = [super init])
    {
        _sprite = [sprite retain];
    }
    return self;
}

-(CCSprite *) sprite
{
    return _sprite;
}

-(void) addedToLayer:(GameLayer *)layer
{
    [layer addChild:_sprite];
}

-(void) removedFromLayer:(GameLayer *)layer
{
    [layer removeChild:_sprite cleanup:TRUE];
}

-(void) setPosition:(CGPoint)position
{
    [_sprite setPosition:position];
}

- (void)dealloc
{
    [_sprite dealloc];
    
    [super dealloc];
}

@end

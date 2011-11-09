//
//  RenderSystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderSystem.h"

#import "RenderComponent.h"
#import "TransformComponent.h"

@implementation RenderSystem

-(id) initWithLayer:(CCLayer *)layer;
{
    if (self = [super init])
    {
        _layer = layer;
    }
    return self;
}

-(void) entityAdded:(Entity *)entity
{
    RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
    [_layer addChild:[renderComponent spriteSheet]];
    
    [super entityAdded:entity];
}

-(void) update
{
    for (Entity *entity in _entities)
    {
        TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
        RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
        
        [[renderComponent spriteSheet] setPosition:[transformComponent position]];
        [[renderComponent spriteSheet] setRotation:[transformComponent rotation]];
    }
}

@end

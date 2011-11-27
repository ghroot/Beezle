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

-(id) initWithLayer:(CCLayer *)layer
{
    if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [RenderComponent class], nil]])
    {
        _layer = layer;
        _spriteSheetsByName = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_spriteSheetsByName release];
    
    [super dealloc];
}

-(RenderComponent *) createRenderComponentWithFile:(NSString *)fileName
{
    CCSpriteBatchNode *spriteSheet = (CCSpriteBatchNode *)[_spriteSheetsByName objectForKey:fileName];
    if (spriteSheet == nil)
    {
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:fileName];
        [_layer addChild:spriteSheet];
        [_spriteSheetsByName setObject:spriteSheet forKey:fileName];
    }
    return [[[RenderComponent alloc] initWithSpriteSheet:spriteSheet] autorelease];
}

-(RenderComponent *) createRenderComponentWithSpriteSheetName:(NSString *)name andFrameFormat:(NSString *)frameFormat
{
    CCSpriteBatchNode *spriteSheet = (CCSpriteBatchNode *)[_spriteSheetsByName objectForKey:name];
    if (spriteSheet == nil)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", name]];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", name]];
        [_layer addChild:spriteSheet];
        [_spriteSheetsByName setObject:spriteSheet forKey:name];
    }
    return [[[RenderComponent alloc] initWithSpriteSheet:spriteSheet andFrameFormat:frameFormat] autorelease];
}

-(void) entityAdded:(Entity *)entity
{
    RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
    [[renderComponent spriteSheet] addChild:[renderComponent sprite] z:[renderComponent z]];
    
    [super entityAdded:entity];
}

-(void) entityRemoved:(Entity *)entity
{
    RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
    [[renderComponent spriteSheet] removeChild:[renderComponent sprite] cleanup:TRUE];
    
    [super entityRemoved:entity];
}

-(void) processEntity:(Entity *)entity
{
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
    
    [[renderComponent sprite] setPosition:[transformComponent position]];
    [[renderComponent sprite] setRotation:[transformComponent rotation]];
    [[renderComponent sprite] setScaleX:[transformComponent scale].x];
    [[renderComponent sprite] setScaleY:[transformComponent scale].y];
}

@end

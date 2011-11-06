//
//  RenderableBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderableBehaviour.h"

@implementation RenderableBehaviour

-(id) initWithFile:(NSString *)fileName;
{
    if (self = [super init])
    {
        _spriteSheet = [[CCSpriteBatchNode batchNodeWithFile:fileName capacity:100] retain];
        _sprite = [[CCSprite spriteWithTexture:_spriteSheet.texture] retain];
        [_spriteSheet addChild:_sprite];
    }
    return self;
}

-(void) addedToLayer:(GameLayer *)layer
{
    [layer addChild:_spriteSheet];
}

-(void) removedFromLayer:(GameLayer *)layer
{
    [layer removeChild:_spriteSheet cleanup:TRUE];
}

-(void) setPosition:(CGPoint)position
{
    [_spriteSheet setPosition:position];
}

- (void)dealloc
{
    [_spriteSheet release];
    [_sprite release];
    
    [super dealloc];
}

@end

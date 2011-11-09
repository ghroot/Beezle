//
//  RenderableBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderComponent.h"

@implementation RenderComponent

@synthesize spriteSheet = _spriteSheet;

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

- (void)dealloc
{
    [_spriteSheet release];
    [_sprite release];
    
    [super dealloc];
}

@end

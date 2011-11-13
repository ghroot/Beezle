//
//  RenderableBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

#import "cocos2d.h"

@interface RenderComponent : Component
{
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
}

@property (nonatomic, readonly) CCSpriteBatchNode *spriteSheet;

-(id) initWithFile:(NSString *)fileName;

@end

//
//  RenderableBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractBehaviour.h"

#import "cocos2d.h"

@interface RenderableBehaviour : AbstractBehaviour
{
    CCSprite *_sprite;
}

-(id) initWithSprite:(CCSprite *)sprite;
-(CCSprite *) sprite;

@end

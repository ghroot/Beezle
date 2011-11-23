//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "slick.h"

@interface CocosGameContainer : GameContainer
{
	CCLayer *_layer;
}

@property (nonatomic, readonly) CCLayer *layer;

@end

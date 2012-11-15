//
//  LevelThemeSelectMenuItem.m
//  Beezle
//
//  Created by Marcus on 07/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FullscreenTransparentMenuItem.h"

@implementation FullscreenTransparentMenuItem

-(id) initWithBlock:(void (^)(id))block width:(float)width;
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCLayerColor *fullscreenLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0) width:width height:winSize.height];

	self = [super initWithNormalSprite:fullscreenLayer selectedSprite:nil disabledSprite:nil block:block];
	return self;
}

-(id) initWithBlock:(void (^)(id))block
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	return [self initWithBlock:block width:winSize.width];
}

@end

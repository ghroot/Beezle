//
//  Dialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"
#import "CoverLayer.h"

@implementation Dialog

-(id) initWithImage:(NSString *)imagePath
{
	if (self = [super init])
	{
		[self addChild:[CoverLayer node]];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		_imageSprite = [[CCSprite alloc] initWithFile:imagePath];
		[_imageSprite setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
		[_imageSprite setScale:0.0f];
		[_imageSprite runAction:[CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.0f]]];
		[self addChild:_imageSprite];
	}
	return self;
}

-(void) dealloc
{
	[_imageSprite release];
	
	[super dealloc];
}

@end

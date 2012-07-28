//
//  Dialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"
#import "CCBReader.h"
#import "CoverLayer.h"

@implementation Dialog

-(id) initWithInterfaceFile:(NSString *)filePath
{
	if (self = [super init])
	{
//		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CoverLayer *coverLayer = [CoverLayer node];
//		[coverLayer setPosition:CGPointMake(-winSize.width / 2, -winSize.height / 2)];
		[self addChild:coverLayer];
		
		CCNode *interface = [CCBReader nodeGraphFromFile:filePath owner:self];
//		[interface setScale:0.2f];
//		[interface runAction:[CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.0f]]];
		[self addChild:interface];		
	}
	return self;
}

@end
